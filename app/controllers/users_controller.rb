class UsersController < ApplicationController
    
  # NEW -- render signup form (GET: /users/new)
  get '/signup' do
    redirect_if_logged_in
    erb :'users/new'
  end

  # CREATE -- accept sign up params and create a user
  post "/users" do
    find_user_by_username

    if @user
      redirect_to("/signup", :warning, "User already exists, <a href='/login'>Log in?</a>")
    else
      @user = User.new(params[:user])
      if params[:user][:username].include?(" ")
        redirect_to("/signup", :error, "Signup failure: Username cannot include spaces.")
      elsif @user.save
        session[:user_id] = @user.id
        redirect_to("/users/#{@user.slug}", :success, "Successfully signed up!")
      else
        redirect_to("/signup", :error, "Signup failure: #{@user.errors.full_messages.to_sentence}")
      end
    end
  end
    
  # render login form
  get '/login' do
    redirect_if_logged_in
    erb :'users/login'
  end
    
  # receive the params from login form
  post '/login' do
    @user = User.find_by(username: params[:username])

    # use .authenticate method to confirm password is correct
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to("/madlibs", :info, "Welcome #{@user.first_name}!")
    elsif !@user
     redirect_to("/login", :error, "Incorrect username. <a href='/signup'>Sign Up?</a>")
    else @user && !@user.authenticate(params[:password])
     redirect_to("/login", :error, "Incorrect password")
    end
  end
    
  # logs out user by clearing session hash
  get '/logout' do
    session.clear
    redirect_to("/", :info, "You are logged out!")
  end

  # INDEX -- index route for all users (GET '/users')
  get '/users/browse' do
    @users = User.all
    erb :'users/browse'
  end

  # SHOW -- show route for user's profile page
  get '/users/:slug' do
    find_user_by_slug
    erb :'users/show'
  end

  # EDIT -- render form for user to edit their profile
  get "/users/:slug/edit" do
    if logged_in?
      find_user_by_slug
      if @user == current_user
        erb :"/users/edit"
      else
        redirect_to("/", :error, "Not yours to edit!")
      end
    else
      redirect_to("/", :error, "Must be logged in to access. <a href='/login'>Log in?</a>")
    end
  end

  # UPDATE -- patch route to update existing user profile
  patch "/users/:slug" do
    redirect_if_not_logged_in("/", :error, "Must be logged in to edit profile. <a href='/login'>Log in?</a>")

    find_user_by_slug
    # if cancelled
    if params.keys.include?("cancel")
      redirect to "/users/#{@user.slug}"
    elsif @user == current_user
      # check if username contains invalid input (spaces)
      if params[:user][:username].include?(" ")
        redirect_to("/users/#{@user.slug}/edit", :error, "Edit failure: Username cannot include spaces.")
      # if successfully updates, check for new_password
      elsif @user.update(first_name: params[:user][:first_name], last_name: params[:user][:last_name], username: params[:user][:username])
        # only update password if params[:new_password] is not blank
        if !params[:user][:new_password].blank?
          @user.update(password: params[:user][:new_password])
        end
        redirect_to("/users/#{@user.slug}", :success, "Profile successfully updated!")
      else
        redirect_to("/users/#{current_user.slug}/edit", :error, "Edit failure: #{@user.errors.full_messages.to_sentence}")
      end
    else
      redirect_to("/", :error, "Not yours to edit!")
    end
  end

  # DESTROY -- renders delete account form
  get '/users/:slug/delete' do
    find_user_by_slug
    if logged_in? && @user == current_user
      erb :"/users/delete"
    else
      redirect_to("/", :error, "Cannot delete profile that is not yours.")
    end
  end

  # DESTROY -- delete route to delete an existing user profile
  delete '/users/:slug/delete' do
    find_user_by_slug
    if logged_in? && @user == current_user
      @user.stories.destroy_all
      @user.destroy
      redirect_to("/", :success, "Your profile has been deleted.")
    else
      redirect_to("/", :error, "Cannot delete profile that is not yours.")
    end
  end

  helpers do
    def find_user_by_slug
      @user = User.find_by_slug(params[:slug])
    end

    def find_user_by_username
      @user = User.find_by(username: params[:user][:username])
    end
  end
end
