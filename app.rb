require 'sinatra'
#require 'thin'
require 'yaml'
require 'date'
require 'json'

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

# Load data

@@outbox = YAML.load(IO.binread("outbox.yml"))["Email"]
@@inbox = YAML.load(IO.binread("data_mail.yml"))["Inbox"]
@@spam = YAML.load(IO.binread("spam.yml"))
@@contact = YAML.load(IO.binread("data_contacts.yml"))["Contact"]
@@trash = []
@@draft = YAML.load(IO.binread("draft.yml"))["Email"]

get '/' do
  @index_active = true
  erb :index
end

get '/inbox' do

  @mail_active = true
  @inbox_active = true
  erb :mail
end

get '/outbox' do
  @mail_active = true
  @outbox_active = true
  erb :mail
end

get '/draft' do
  @mail_active = true
  @draft_active = true
  erb :mail
end

get '/spam' do
  @mail_active = true
  @spam_active = true
  erb :mail
end

get '/trash' do
  @mail_active = true
  @trash_active = true
  erb :mail
end

get '/contact' do
  @contact_active = true
  erb :contact
end

get '/setting' do
  @setting_active = true
  erb :setting
end

get '/search_mail' do
  @mail_active = true
  erb :search_results_mail
end

get '/search_contact' do
  @contact_active = true
  erb :search_results_contact
end

get '/mark_spam/:id' do
  marked_spam = @@inbox.delete_at(params['id'].to_i)
  @@spam.unshift(marked_spam)
  redirect to('/inbox')
end

get '/mark_trash/:id' do
  marked_delete = @@inbox.delete_at(params['id'].to_i)
  @@trash.unshift(marked_delete)
  redirect to('/inbox')
end

get '/get_message/:id' do
  JSON.generate @@inbox[params['id'].to_i]
end

get '/get_message_outbox/:id' do
  JSON.generate @@outbox[params['id'].to_i]
end

get '/get_message_draft/:id' do
  JSON.generate @@draft[params['id'].to_i]
end

get '/get_message_trash/:id' do
  JSON.generate @@trash[params['id'].to_i]
end

post '/send_email' do
  @@outbox.unshift({"Date"=>date_string,
                    "Sender"=> params["email"],
                    "Title"=> params["title"], 
                    "Content"=> params["content"],
                    "Attachment"=> params["attachment"],
                    "Excerpt"=>params["content"].split.first(4).join(" ")})

  redirect to('/inbox')
end


post '/create_contact' do
  @@contact.unshift({
      "Name"=> params["name"],
      "Email"=> params["email"],
      "Address"=> params["address"],
      "Phone"=> params["phone"]
    })

 redirect to('/contact')
end