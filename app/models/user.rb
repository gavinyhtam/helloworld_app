class User < ActiveRecord::Base
	has_many :photos

	before_save { username.downcase! } #ensure username is stored as lowercase

	VALID_USERNAME_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :username, 
		presence: true, 
		uniqueness: {case_sensitive: false},
		format: {with: VALID_USERNAME_REGEX}
end