class UsersController < ApplicationController

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show_user'
  end
    
  get '/signup' do
    redirect_if_logged_in
    erb :'users/new_user'
  end
    
  post '/signup' do
    if params[:first_name] == "" || params[:last_name] == "" || params[:username] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(params)
      @user.save
      session[:user_id] = @user.id
      redirect to '/madlibs'
    end
  end
    
  get '/login' do
    redirect_if_logged_in
    erb :'users/login'
  end
    
  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/madlibs"
    else
      redirect to '/signup'
    end
  end
    
  get '/logout' do
    redirect_if_not_logged_in

    session.clear
    redirect to '/login'
  end
end
