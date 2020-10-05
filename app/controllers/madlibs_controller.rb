class MadlibsController < ApplicationController
    get '/madlibs' do
        if logged_in?
          @madlibs = Madlib.all
          erb :'madlibs/madlibs'
        else
          redirect to '/login'
        end
    end
    
    # get '/madlibs/:id/new' do
    #     @madlib = Madlib.find_by_id(params[:id])
    #     if logged_in?
    #         erb :'tweets/new'
    #     else
    #         redirect '/login'
    #     end
    # end
end
