class MadlibsController < ApplicationController
  # INDEX -- index route for all completed mad libs (stories)
  get '/madlibs' do
    @madlibs = Madlib.all
    erb :'madlibs/madlibs'
  end
end
