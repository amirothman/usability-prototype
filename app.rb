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
  @dummy_mail = dummy_mail(15)
  erb :mail
end

get '/outbox' do
  @mail_active = true
  @outbox_active = true
  @dummy_mail = dummy_mail(30)
  erb :mail
end

get '/draft' do
  @mail_active = true
  @draft_active = true
  @dummy_mail = dummy_mail(9)
  @dummy_mail_read = dummy_mail(21)
  erb :mail
end

get '/spam' do
  @mail_active = true
  @spam_active = true
  @dummy_mail = dummy_mail(11)
  @dummy_mail_read = dummy_mail_read(19)
  erb :mail
end

get '/trash' do
  @mail_active = true
  @trash_active = true
  @dummy_mail = dummy_mail(15)
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

def dummy_mail n
  yaml = IO.binread("fixtures.yml")
  hash = YAML.load(yaml)
  (1..n).map{|idx| hash["Email"].sample }
end