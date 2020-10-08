class MadlibsController < ApplicationController
  get '/madlibs' do
    @madlibs = Madlib.all
    erb :'madlibs/madlibs'
  end
end
