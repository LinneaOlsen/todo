require 'sinatra'
require 'data_mapper'
load 'datamapper_setup.rb'

class Todo
  include DataMapper::Resource

  property :id,         Serial  # An auto-increment integer key
  property :title,       String
  property :time,       Integer
  property :description,  String
  property :importance,   Boolean
  property :urgent,       Boolean
  property :completed,    Boolean
  property :archived,     Boolean
end

class MindTheCodeApp < Sinatra::Application

  set :partial_template_engine, :erb
  set :static, true

  # Want your views to be served from a different folder?
  # see http://www.sinatrarb.com/configuration.html
  # And an example:
  # set :views, Proc.new { File.join(root, "some-other-folder") }

  # CONSTANT = ConstantObject.new

  get '/' do
    @todos = Todo.all
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '/' do
    puts "These are our #{params}"
    todo = Todo.new(params[:todo])    

    if todo.save
      redirect '/'
    else
      redirect '/new'
    end
  end

  get '/order/:field/:order' do |field, order|
    sort_field = field.to_sym

    if order == 'desc'
      sorting = sort_field.desc
    else
      sorting = sort_field.asc
    end

    @todos = Todo.all(:order =>[sorting])
    erb :index
  end

  get '/todo/done/:todo_id' do |todo_id|
    "Hello World #{todo_id}"
    todo = Todo.get(todo_id) 
    todo.completed = true 
    todo.inspect

    if todo.save
      redirect '/'
    else
      redirect '/new'
    end
  end

  get '/todo/archived' do 
    @todos = Todo.all 
      @todos.each do |todo| 
        if todo.completed == true
          todo.archived = true
          todo.save
        end
      end
        redirect '/'
  end

  # ROUTING EXAMPLES
  # post '/' do
  #   @object = "an object that is accessible from the view"
  #   redirect '/' # redirects bounce to a GET route by default
  # end
  #
  # get '/dogs/:name' do
  #   @dog = Dog.where(name: params[:name])
  #   erb :dog
  # end

end
