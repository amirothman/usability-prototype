require 'sinatra'
#require 'thin'
require 'yaml'
require 'date'
enable :sessions

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

@@outbox = []
@@inbox = YAML.load(IO.binread("inbox.yml"))["Email"]
@@spam = YAML.load(IO.binread("spam.yml"))
@@contact = YAML.load(IO.binread("data_contacts.yml"))["Contact"]
@@trash = []
@@result_contact = []

get '/' do
  @index_active = true
  erb :index
end

get '/inbox' do

  @mail_active = true
  @inbox_active = true
  @dummy_mail = dummy_mail
  erb :mail
end

get '/outbox' do
  @mail_active = true
  @outbox_active = true
  @dummy_mail = dummy_mail_outbox
  erb :mail
end

get '/draft' do
  @mail_active = true
  @draft_active = true
  @dummy_mail_draft = dummy_mail_draft
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
  @setting_active =true
  erb :setting
end

get '/search_mail' do
  @mail_active = true
  @dummy_mail = @@inbox
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

post '/send_email' do

  # add to the beginning of @@outbox
  date = DateTime.now
  date_string = "#{add_necessary_zero(date.day)}/#{add_necessary_zero(date.month)}/#{add_necessary_zero(date.year)} #{add_necessary_zero(date.hour)}:#{add_necessary_zero(date.minute)}"
  print params
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

post '/search_contact'  do
  #@@result_contact = @@contact. params["query"]
  print(@@contact)
  @@result_contact = @@contact.map do |contact|
    contact["Name"].match(params["query"])
  end
  @@result_contact.delete(nil)
  print(@@result_contact)
  redirect to('/search_contact')
end

def dummy_mail
  @@inbox
end

def dummy_mail_outbox
  yaml = IO.binread("outbox.yml")
  arr = YAML.load(yaml)["Email"]
  @@outbox.each do |msg|
    arr.unshift(msg)
  end
  arr
end

def dummy_mail_draft
  yaml = IO.binread("draft.yml")
  YAML.load(yaml)["Email"]
end

def add_necessary_zero n
  if n < 10
    "0#{n}"
  else
    "#{n}"
  end
end