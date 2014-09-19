class TodosController < ApplicationController
 skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	include LocationCode
  def index
		#determines whether introduction of web app to new users should be shown
		@new_user = session[:new_user];
		session[:new_user] = false;
		@user = User.find_or_create_by(username: cookies[:username])	#find or create the logged in user
		@locations = [];
		@user.photos.each do |photo|
			#add unique locations to the @locations (inefficient but will change to use a set instead)
			@locations.push(code(photo.location_name)) unless @locations.include? code(photo.location_name)
		end
  end

	def friends
		@user = User.find_or_create_by(username: cookies[:username])	#find or create the logged in user
	end
	
	def create
		respond_to do |format|
			format.json { render :json => { msg: country(params[:countryname]) } } #message for AJAX response
		end
	end

	def createPhoto
		@user = User.find_by(username: cookies[:username])
		#if photo already exists, update attributes
		photo = @user.photos.find_by(link: params[:link])
		if (photo)
			photo.update_attributes(location_name: params[:location_name], date: params[:date], photo_name: params[:photo_name])
			respond_to do |format|
				format.json { render :json => { msg: "Updated photo information!" } }
			end
		else
		#create the photo from the given attributes
			@user.photos.build(link: params[:link], location_name: params[:location_name], date: params[:date], photo_name: params[:photo_name])
			if @user.save	#if the photo was saved successfully
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
end
