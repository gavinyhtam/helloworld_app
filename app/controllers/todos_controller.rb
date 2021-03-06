class TodosController < ApplicationController
 skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	include LocationCode
  def index
		#determines whether introduction of web app to new users should be shown
		@new_user = cookies[:new_user]
		session[:new_user] = false
		@user = User.find_or_create_by(fb_id: cookies[:fb_id])	#find or create the logged in user
		@all_friends = User.all
		@locations = []
		@all_friends.each do |friend|
			friend.photos.each do |photo|
				#add unique locations to the @locations (inefficient but will change to use a set instead)
				@locations.push(code(photo.location_name)) unless @locations.include? code(photo.location_name)
			end
		end
  end

	def friends
		@users = User.all
		@user = User.find_or_create_by(fb_id: cookies[:fb_id])	#find or create the logged in user
		sorted_photos = @user.photos.sort_by &:updated_at
		if (sorted_photos.length >= 1)
			#get most recent location
			@recent_location = sorted_photos[0].location_name 
			#get all photos from this recent location
			@recent_photos = @user.photos.where(location_name: @recent_location)
		else	#if no photos uploaded by user
			@recent_location = "nowhere"
			@recent_photos = []
		end
		puts @recent_photos

		@friend_photo_stats = Hash.new(0)
		@friend_location_stats = Hash.new(0)
		@locations = []
		@users.each do |friend|
			@friend_photo_stats[friend.fb_id] = friend.photos.length	#count number of photos uploaded
			friend_locations = Hash.new
			friend.photos.each do |photo|
				#unless location for friend was already added
				unless friend_locations[photo.location_name]
					@friend_location_stats[friend.fb_id] += 1;	#count number of locations visited
				end
				#see location as visited
				friend_locations[photo.location_name] = 1
				#add unique locations to the @locations (inefficient but will change to use a set instead)
				unless @locations.include? code(photo.location_name)
					@locations.push(code(photo.location_name))
				end
			end
		end
	end
	
	def create
		respond_to do |format|
			format.json { render :json => { msg: country(params[:countryname]) } } #message for AJAX response
		end
	end

	#create a new record in the database for a given new photo,
	#or updates photo information e.g. changes in title, date or location
	def createPhoto
		@user = User.find_by(fb_id: cookies[:fb_id])
		#if photo already exists, update attributes
		photo = @user.photos.find_by(photo_id: params[:photo_id])
		if (photo)
			photo.update_attributes(location_name: params[:location_name], date: params[:date], 
											photo_name: params[:photo_name], link: params[:link])
			respond_to do |format|
				format.json { render :json => { msg: "Updated photo information!" } }
			end
		else
		#create the photo from the given attributes
			@user.photos.build(link: params[:link], location_name: params[:location_name], 
				date: params[:date], photo_name: params[:photo_name], photo_id: params[:photo_id])
			if @user.save	#if the photo was saved successfully
				@user.locations.build(location_name: params[:location_name])
				@user.save unless @user.locations.find_by(location_name: params[:location_name])
				respond_to do |format|
					format.json { render :json => { msg: "Posted!" } }
				end
			else
				respond_to do |format|
					format.json { render :json => { msg: "Error! Photo not saved." } }
				end
			end
		end
	end

	#finds the user associated with the given FB id and returns user info,
	#locations visited and recent photos
	def friendPhotos
		id = params[:id]
		country = params[:location]
		@user = User.find_by(fb_id: id)
		locations = @user.locations.all
		@locations = []
		locations.each do |location|
			@locations.push(code(location.location_name))  unless @locations.include? code(location.location_name)
		end
		if (country)
			@photos = @user.photos.where(location_name: country)
			respond_to do |format|
				format.json { render :json => { msg: @photos, user: @user }}
			end
		else
			sorted_photos = @user.photos.sort_by &:updated_at
			if (sorted_photos.length >= 1)
				@recent_location = sorted_photos[0].location_name 
				@recent_photos = @user.photos.where(location_name: @recent_location)
			else
				@recent_location = "nowhere"
				@recent_photos = []
			end
			respond_to do |format|
				format.json { render :json => { msg: @recent_photos, user: @user, locations: @locations }}
			end
		end
	end

	#finds the country, users and user profiles associated with a given country code
	def findLocation
		location = params[:location]
		@users = Location.where(location_name: country(location))
		@user_profiles = []
		@users.each do |user|
			#get user profiles of users who have visited the location
			@user_profiles.push(User.find_by(id: user.user_id))
		end
		respond_to do |format|
			format.json { render :json => { country: country(location), msg: @users, profiles: @user_profiles }}
		end
	end
end
