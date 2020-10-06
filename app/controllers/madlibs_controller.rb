class MadlibsController < ApplicationController
    get '/madlibs' do
        if logged_in?
          @madlibs = Madlib.all
          erb :'madlibs/madlibs'
        else
          redirect to '/login'
        end
    end
end
