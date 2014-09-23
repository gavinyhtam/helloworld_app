class Location < ActiveRecord::Base
	belongs_to	:user
	validates :location_name, presence: true
end
