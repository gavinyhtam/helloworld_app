class Photo < ActiveRecord::Base
	include LocationCode
	belongs_to :user

	before_save { link.downcase! }

	VALID_LINK_REGEX = /\Ahttp:\/\/www.[a-z.]+[a-z]+\z/i
	validates :link, presence: true, format: { with: VALID_LINK_REGEX }
	validates :location_name, presence: true

	#converts name of country into location code readable by AmMaps
	def location_code
		code(location_name)	#code method is defined in LocationCode module
	end
end
