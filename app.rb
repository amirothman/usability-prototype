require 'sinatra'
require 'thin'
require 'yaml'
enable :sessions

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

def dummy_mail
  yaml = IO.binread("inbox.yml")
  YAML.load(yaml)["Email"]
end

def dummy_mail_outbox
  yaml = IO.binread("outbox.yml")
  YAML.load(yaml)["Email"]
end

def dummy_mail_draft
  yaml = IO.binread("draft.yml")
  YAML.load(yaml)["Email"]
end