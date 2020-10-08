class Story < ActiveRecord::Base
    belongs_to :user
    belongs_to :madlib

    # Creates new story instance from session and params hash
    def self.create_from_session_and_params(session, params)
        madlib = Madlib.all.find_by_id(session[:madlib_id])

        new_story = Story.create(sentence: madlib.sentence)
        new_story.madlib_id = madlib.id
        new_story.input = new_story.convert_param_into_input_string(params)
        new_story
    end

    # Converts user inputs from form into string format
    def convert_param_into_input_string(params)
        inputs = ""
        params[:blanks].each do | key, value |
            if value != ""
                inputs << value.strip + "-"
            else
                inputs << self.convert_input_string_into_array[key.to_i] + "-"
            end
        end
        inputs
    end

    # Converts user inputs from form into array
    def convert_input_string_into_array
        self.input.split('-')
    end

    # Returns complete story string
    def create_story
        story = ""
        self.madlib.words.each_with_index do | sentence, i |
            story << sentence if sentence
            story << self.convert_input_string_into_array[i] if self.convert_input_string_into_array[i]
        end
        story
    end
end