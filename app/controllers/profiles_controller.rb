class ProfilesController < ApplicationController
  def index
		@users = User.all
		@user = User.find_by(fb_id: cookies[:fb_id])
		if @user.photos.size >= 1	#if more than one photo uploaded
			#get the most recent location
			@last_location = @user.photos.order(:date).last.location_name;
			#get all photos from this recent location
			@last_location_photos = @user.photos.where(location_name: @last_location);
			@locations = Hash.new
			@user.photos.each do |photo|
				#add locations visited
				@locations[photo.location_name] = 1
			end
		else	#if no photo uploaded
			@last_location = "nowhere"
			@last_location_photos = []
			@locations = Hash.new
		end
  end

	def friend
		@users = User.all
		@user_id = params[:id]
		@user = User.find_by(fb_id: params[:id])
		if @user.photos.size >= 1 #if more than one photo uploaded
			#get the most recent location
			@last_location = @user.photos.order(:date).last.location_name;
			#get all photos from this recent location
			@last_location_photos = @user.photos.where(location_name: @last_location);
			@locations = Hash.new
			@user.photos.each do |photo|
				#add locations visited
				@locations[photo.location_name] = 1
			end
		else #if no photo uploaded
			@last_location = "nowhere"
			@last_location_photos = []
			@locations = Hash.new
		end
	end
end
