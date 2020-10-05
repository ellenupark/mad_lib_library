class Madlib < ActiveRecord::Base
    has_many :stories
    has_many :users, through: :stories

    def words
        self.sentence.split('-')
    end

    def inputs
        self.blank.split('-')
    end

end