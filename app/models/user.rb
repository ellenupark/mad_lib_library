class User < ActiveRecord::Base
    has_many :stories
    has_many :madlibs, through: :stories

    has_secure_password
    
    validates :first_name, :last_name, :username, :password, presence: true
    validates :username, uniqueness: true
    
    #lowercase, no leading or trailing whitespace, replace spaces with hyphens
    def slug
        username.downcase.gsub(" ","-")
    end
    
    def self.find_by_slug(slug)
        User.all.find{ | user | user.slug == slug }
    end
end