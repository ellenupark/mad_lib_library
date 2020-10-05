class StoriesController < ApplicationController
  get '/stories' do
    if logged_in?
      @stories = Story.all.where(user_id: current_user.id)
      erb :'stories/stories'
    else
      redirect to '/login'
    end
  end
    
  get '/stories/:id/new' do
    redirect_if_not_logged_in

    @madlib = Madlib.find_by_id(params[:id])

    session[:madlib_id] = @madlib.id
    session[:sentence] = @madlib.sentence

    @success_message = session[:success_message]
    session[:success_message] = nil

    erb :'stories/new_story'

  end
    
  post '/stories' do
    redirect_if_not_logged_in

    if params.values.include?("")
      session[:success_message] = "Input Missing"

      redirect to "/madlibs/#{params[:madlib_id]}/new"
    else
      @story = Story.create_from_session_and_params(session, params)
        
      @story.user_id = current_user.id
      if @story.save
        session[:success_message] = "Successfully created song."
        redirect to "/stories/#{@story.id}"
      else
        redirect to "/madlibs/#{params[:madlib_id]}/new"
      end
    end
  end
    
  get '/stories/:id' do
    redirect_if_not_logged_in
    @story = Story.find_by_id(params[:id])

    @success_message = session[:success_message]
    session[:success_message] = nil

    erb :'stories/show_story'
  end
  
  get '/stories/:id/edit' do
    redirect_if_not_logged_in
    @story = Story.find_by_id(params[:id])
      if @story && @story.user == current_user
        erb :'stories/edit_story'
      else
        redirect '/stories'
      end
  end
  
  patch '/stories/:id' do
    redirect_if_not_logged_in
    @story = Story.find_by_id(params[:id])
    if @story && @story.user == current_user
      if @story.update(input: @story.create_input_string_from_params(params))
        session[:success_message] = "Mad lib successfully updated."
        redirect "/stories/#{@story.id}"
      else
        redirect "/stories/#{@story.id}/edit"
      end
    else
      redirect '/stories'
    end
  end
  
  delete '/stories/:id/delete' do
    redirect_if_not_logged_in

    @story = Story.find_by_id(params[:id])
    
    if @story && @story.user_id == current_user.id
      @story.delete
    end

    redirect '/stories'

  end
end
