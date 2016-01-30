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

@@outbox = YAML.load(IO.binread("outbox.yml"))["Email"]
@@inbox = YAML.load(IO.binread("inbox.yml"))["Email"]
@@spam = YAML.load(IO.binread("spam.yml"))
@@trash = []
@@draft = YAML.load(IO.binread("draft.yml"))["Email"]

get '/' do
  @index_active = true
  erb :index
end

get '/contact' do
  @dummy_contact = dummy_contact
  erb :contact
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

def dummy_mail
  @@inbox
end

def dummy_mail_outbox
  @@outbox
end

def dummy_mail_draft
  @@draft
end

def dummy_contact
  yaml = IO.binread("data_contacts.yml")
  YAML.load(yaml)["Contact"]
end

def add_necessary_zero n
  if n < 10
    "0#{n}"
  else
    "#{n}"
  end
end