require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions, true
    set :session_secret, "secret"
  end

  get "/" do
    redirect_if_logged_in
    erb :index
  end

  helpers do
		def logged_in?
			!!current_user
		end

		def current_user
			@current_user ||= User.find_by(id: session[:user_id])
    end
    
    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login"
      end
    end
    
    def redirect_if_logged_in
      if logged_in?
        redirect "/madlibs"
      end
    end
    
  end


end
