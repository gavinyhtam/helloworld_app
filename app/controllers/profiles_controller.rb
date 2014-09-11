class ProfilesController < ApplicationController
  def index
		@user = User.find_by(username: cookies[:username])
		if @user.photos.size > 1
			@last_location = @user.photos.order(:date).find(1);
			@last_location_photos = @user.photos.where(location_name: @last_location.location_name);
			puts @last_location_photos
			@locations = []
			@user.photos.each do |photo|
				#add unique locations to the @locations (inefficient but will change to use a set instead)
				@locations.push(photo.location_name) unless @locations.include? photo.location_name
			end
		end
  end
end
