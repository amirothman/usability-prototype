require 'sinatra'
require 'thin'
require 'yml'
enable :sessions

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
  @setting_active =true
  erb :setting
end

get '/search_results' do
  @search_results_active = true
  erb :search_results
end

def dummy_mail n

end