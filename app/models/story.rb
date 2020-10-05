class Story < ActiveRecord::Base
    belongs_to :user
    belongs_to :madlib

    def self.create_from_session_and_params(session, params)
        madlib = Madlib.all.find_by_id(session[:madlib_id])
        new_story = Story.create(sentence: madlib.sentence)
        new_story.madlib_id = madlib.id
        new_story.input = new_story.create_input_string_from_params(params)
        new_story
    end

    def create_input_string_from_params(params)
        params.delete("submit")
        params.delete("_method")
        params.delete("id")

        inputs = ""
        params.each do | key, value |
            if value != ""
                inputs << value + "-"
            else
                inputs << self.input_as_array[key.to_i] + "-"
            end
        end
        inputs
    end

    def input_as_array
        self.input.split('-')
    end

    def create_story
        story = ""
        self.madlib.words.each_with_index do | sentence, i |
            story << sentence if sentence
            story << self.input_as_array[i] if self.input_as_array[i]
        end
        story
    end



    

end