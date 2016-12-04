ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'


class Chitter < Sinatra::Base
  enable :sessions
  set :session_secret, "himitsu"
  register Sinatra::Flash

  get '/' do
    'Hello Chitter!'
  end

  get '/users/new' do
    erb :newuser
  end

  post '/users' do
    new_user = User.create(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])

    if new_user.save
      flash[:welcome] = "Welcome to Chitter, #{params[:username]}!"
      redirect to('/dashboard')
    else
      flash[:mismatch] = "Passwords don't match, try again"
      redirect to('/users/new')
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    if User.login(params[:username], params[:password])
      flash[:login_succesful] = "Welcome back, #{params[:username]}!"
      redirect to('/dashboard')
    else
      flash[:login_unsuccesful] = "Wrong username or password"
      redirect to('sessions/new')
    end
  end

  get '/dashboard' do
    erb :dashboard
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
