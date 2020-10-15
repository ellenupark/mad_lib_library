require './config/environment'
require 'sinatra/base'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  # control whether features are enabled or not
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    # turns sessions on
    enable :sessions
    # encryption key that will be used to create a session_id
    set :session_secret, "speakerjournalconvictionberrycartshylickinjection"
    register Sinatra::Flash

  end

  # root route - welcome/home page
  get "/" do
    erb :index
  end

  helpers do
		def logged_in?
			!!current_user
		end

		def current_user
			@current_user ||= User.find_by(id: session[:user_id])
    end
    
    def redirect_if_not_logged_in(route, type, message)
      if !logged_in?
        flash[type] = message
        redirect route
      end
    end
    
    def redirect_if_logged_in
      if logged_in?
        redirect "/madlibs"
      end
    end

     # set flash key/value and redirect to route
    def redirect_to(route, type, message)
      flash[type] = message
      redirect route
    end
    
  end


end
