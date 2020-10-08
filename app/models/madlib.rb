class Madlib < ActiveRecord::Base
    has_many :stories
    has_many :users, through: :stories

    # Converts 'sentence' string to array
    def words
        self.sentence.split('-')
    end

    # Converts 'blank' string into array
    def blanks
        self.blank.split('-')
    end

    def slug
        title.strip.downcase.gsub(" ","-")
    end
    
    def self.find_by_slug(slug)
        Madlib.all.find{ | madlib | madlib.slug == slug }
    end

end