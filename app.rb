require 'sinatra'
# require 'thin'
require 'yaml'
require 'time'
require 'json'

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
  
end

# Load data
enable :sessions


@@outbox = YAML.load(IO.binread("outbox.yml"))["Email"]
@@inbox = YAML.load(IO.binread("data_mail.yml"))["Inbox"]
@@spam = YAML.load(IO.binread("spam.yml"))
@@contact = YAML.load(IO.binread("data_contacts.yml"))["Contact"]
@@trash = []
@@draft = YAML.load(IO.binread("draft.yml"))["Email"]
@@result_contact= []

def zero_padding number
  if number < 10
    "0#{number}"
  else
    "#{number}"
  end
end

get '/' do
  session["notification_message"] = nil
  @index_active = true
  erb :index
end

get '/close_flash' do
  session["notification_message"] = nil
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
  @results = @@inbox.map do |mail|
    if mail["Sender"].downcase.match(params["search_query"].downcase) || mail["SenderEmail"].downcase.match(params["search_query"].downcase) || mail["Content"].downcase.match(params["search_query"].downcase)
      mail
    end
  end
  @results.delete(nil)
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

get '/reset' do 
  @@outbox = YAML.load(IO.binread("outbox.yml"))["Email"]
  @@inbox = YAML.load(IO.binread("data_mail.yml"))["Inbox"]
  @@spam = YAML.load(IO.binread("spam.yml"))
  @@contact = YAML.load(IO.binread("data_contacts.yml"))["Contact"]
  @@trash = []
  @@draft = YAML.load(IO.binread("draft.yml"))["Email"]
  @@result_contact= []

  redirect to('/inbox')
end

post '/send_email' do
  
  now = Time.now

  date_string = "#{zero_padding now.day}/#{zero_padding now.month}/#{zero_padding now.year} #{zero_padding now.hour}:#{zero_padding now.min}"
  if params["send"]
    session["notification_message"] = "Email sent!"
    if params["email"].include?(",")
      params["email"].split(",").each do |email|
        @@outbox.unshift({
                        "Date"=>date_string,
                        "Sender"=> email,
                        "Title"=> params["title"], 
                        "Content"=> params["content"],
                        "Attachment"=> params["attachment"],
                        "Excerpt"=>params["content"].split.first(4).join(" ")})
      end
    else

      @@outbox.unshift({
                        "Date"=>date_string,
                        "Sender"=> params["email"],
                        "Title"=> params["title"], 
                        "Content"=> params["content"],
                        "Attachment"=> params["attachment"],
                        "Excerpt"=>params["content"].split.first(4).join(" ")})
    end

  elsif params["save"]
    session["notification_message"] = "Email saved!"
    @@draft.unshift({
                        "Date"=>date_string,
                        "Sender"=> params["email"],
                        "Title"=> params["title"], 
                        "Content"=> params["content"],
                        "Attachment"=> params["attachment"],
                        "Excerpt"=>params["content"].split.first(4).join(" ")})
  end
  redirect to('/inbox')
end


post '/create_contact' do

  session["notification_message"] = "Contact created!"
  @@contact.unshift({
      "Name"=> params["name"],
      "Email"=> params["email"],
      "Address"=> params["address"],
      "Phone"=> params["phone"]
    })

 redirect to('/contact')

end

post '/search_contact'  do
  @@result_contact = @@contact.map do |contact|
    if contact["Name"].match(params["query"])
      contact
    end
  end
  @@result_contact.delete(nil)
  redirect to('/search_contact')
end

get '/search_contact' do
  erb :search_results_contact
end
