class StoriesController < ApplicationController
  
  # INDEX -- index route for all completed mad libs (stories)
  get '/stories' do
    if logged_in?
      @stories = Story.all.where(user_id: current_user.id)
      erb :'stories/stories'
    else
      redirect_to("/login", :error, "Must be logged in to view mad libs")
    end
  end

  # NEW -- render form to create new story
  get '/stories/:slug/new' do
    redirect_if_not_logged_in("/madlibs", :error, "Must be logged in to complete mad libs. <a href='/login'>Log in?</a>")
    @madlib = Madlib.find_by_slug(params[:slug])
    session[:madlib_id] = @madlib.id
    session[:sentence] = @madlib.sentence

    erb :'stories/new'

  end
    
  # CREATE -- post route to create new story
  post '/stories' do
    redirect_if_not_logged_in("/", :error, "Must be logged in to create a new recipe")
    binding.pry

    if params[:blanks].values.any?{ | value | value[/\s+/] == value || value == "" }
      redirect_to("/stories/#{session[:madlib_id]}/new", :error, "Input Missing")
    elsif params[:blanks].values.any?{ | value | value[/[a-zA-Z0-9 ]*/]  != value }
      redirect_to("/stories/#{session[:madlib_id]}/new", :error, "Creation failure: Invalid input. Please enter letters or numbers only.")
    else
      @story = Story.create_from_session_and_params(session, params)
      @story.user_id = current_user.id

      if @story.save
        redirect_to("/stories/#{@story.id}", :success, "Successfully completed mad lib.")
      else
        redirect_to("/stories/#{params[:madlib_id]}/new", :error, "Creation failure: #{@story.errors.full_messages.to_sentence}")
      end
    end
  end

  # SHOW -- show route for single recipe (dynamic)
  get '/stories/:id' do

    redirect_if_not_logged_in("/", :error, "Must be logged in to view mad libs.")
    @story = Story.find_by_id(params[:id])

    erb :'stories/show'
  end
  
  get '/stories/:id/edit' do
    redirect_if_not_logged_in("/", :error, "Must be logged in to edit mad libs.")
    @story = Story.find_by_id(params[:id])
      if @story && @story.user == current_user
        erb :'stories/edit'
      else
        redirect_to("/stories/#{@story.id}", :error, "Edit Failure: This is not your story.")
      end
  end
  
  patch '/stories/:id' do
    redirect_if_not_logged_in("/", :error, "Must be logged in to edit mad libs.")
    
    @story = Story.find_by_id(params[:id])
    binding.pry
    if params[:blanks].values.any?{ | value | value[/\s+/] == value }
      redirect_to("/stories/#{@story.id}/edit", :error, "Update failure: Input field cannot contain whitespace only.")
    elsif params[:blanks].values.any?{ | value | value[/[a-zA-Z0-9 ]*/]  != value }
      redirect_to("/stories/#{@story.id}/edit", :error, "Edit Failure: Invalid input. Please enter letters or numbers only.")
    else
      if @story && @story.user == current_user
        if @story.update(input: @story.convert_param_into_input_string(params))
          redirect_to("/stories/#{@story.id}", :success, "Mad lib successfully updated.")
        else
          redirect_to("/stories/#{@story.id}/edit", :error, "Update failure: #{@story.errors.full_messages.to_sentence}") 
        end
      else
        redirect_to("/stories/#{@story.id}", :error, "Update failure: This is not your story.")
      end
    end
  end
  
  delete '/stories/:id/delete' do
    redirect_if_not_logged_in("/", :error, "Must be logged in to delete mad libs.")

    @story = Story.find_by_id(params[:id])
    if @story && @story.user_id == current_user.id
      @story.delete
    end
    redirect_to("/stories", :success, "Deleted #{@story.madlib.title}")

  end
end
