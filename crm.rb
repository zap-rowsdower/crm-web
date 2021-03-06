require './rolodex.rb'
require 'sinatra'
require 'sinatra/content_for'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  attr_accessor :id, :first_name, :last_name, :email, :note

  def initialize(first_name, last_name, email, note)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @note = note
  end
  
end

@@rolodex = Rolodex.new

@@rolodex.add(Contact.new("Brock", "Whitbread", "brock.whitbread@gmail.com", "The New Guy"))

get '/contacts/new' do
  erb :new
end

get "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get '/contacts' do 
  erb :contacts
end

get '/' do
  @crm_app_name = "Brock's CRM"
  erb :index
end

post '/contacts' do
  puts params
  contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  @@rolodex.add(contact)
  redirect to('/contacts')
end

get '/contacts/:id/edit' do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :edit
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

delete "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    @@rolodex.remove(@contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

