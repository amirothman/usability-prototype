require 'sinatra'
require 'thin'
require 'yaml'
require 'date'
enable :sessions

@@outbox = []

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
  @dummy_mail = dummy_mail
  @dummy_mail_read = dummy_mail
  erb :mail
end

get '/trash' do
  @mail_active = true
  @trash_active = true
  @dummy_mail = dummy_mail
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

get '/search_results' do
  @search_results_active = true
  erb :search_results
end

post '/send_email' do

  # add to the beginning of @@outbox
  date = DateTime.now
  date_string = "#{date.day}/#{date.month}/#{date.year} #{d.hour}:#{d.minute}"

  @@outbox.unshift({"Date"=>date_string,
                    "Sender"=> params["email"],
                    "Title"=> params["title"], 
                    "Content"=> params["content"],
                    "Attachment"=> params["attachment"],
                    "Excerpt"=>params["content"].split.first(4).join(" ")})

  redirect to('/inbox')
end

def dummy_mail
  yaml = IO.binread("inbox.yml")
  YAML.load(yaml)["Email"]
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