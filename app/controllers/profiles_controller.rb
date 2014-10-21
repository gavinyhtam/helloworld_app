class ProfilesController < ApplicationController
  def index
		@users = User.all
		@user = User.find_by(fb_id: cookies[:fb_id])
		if @user.photos.size >= 1
			@last_location = @user.photos.order(:date).last;
			@last_location_photos = @user.photos.where(location_name: @last_location.location_name);
			puts @last_location_photos
			@locations = []
			@user.photos.each do |photo|
				#add unique locations to the @locations (inefficient but will change to use a set instead)
				@locations.push(photo.location_name) unless @locations.include? photo.location_name
			end
		else
			@last_location = "nowhere"
			@last_location_photos = []
			@locations = []
		end
  end

	def friend
		@users = User.all
		@user_id = params[:id]
		@user = User.find_by(fb_id: params[:id])
		if @user.photos.size >= 1
			@last_location = @user.photos.order(:date).first;
			@last_location_photos = @user.photos.where(location_name: @last_location.location_name);
			puts @last_location_photos
			@locations = []
			@user.photos.each do |photo|
				#add unique locations to the @locations (inefficient but will change to use a set instead)
				@locations.push(photo.location_name) unless @locations.include? photo.location_name
			end
		else 
			@last_location = "nowhere"
			@last_location_photos = []
			@locations = []
		end
	end
end
