class User < ActiveRecord::Base
	has_many :photos
	has_many :locations

	before_save { username.downcase! } #ensure username is stored as lowercase

	VALID_USERNAME_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :username, 
		presence: true, 
		uniqueness: {case_sensitive: false},
		format: {with: VALID_USERNAME_REGEX}
	validates	 :first_name,
		presence: true
	validates :last_name,
		presence: true
	validates :fb_id,
		presence: true, uniqueness: true
end
