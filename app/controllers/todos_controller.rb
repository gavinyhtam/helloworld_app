class TodosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	include LocationCode
  def index
		@user = User.find_or_create_by(username: session[:username])	#find or create the logged in user
		@locations = []
		@user.photos.each do |photo|
			#add unique locations to the @locations (inefficient but will change to use a set instead)
			@locations.push(code(photo.location_name)) unless @locations.include? code(photo.location_name)
		end
		#@locations.push("KR","SG")	#hardcode countries to colour on the map first
  end
	
	def create
		respond_to do |format|
			format.json { render :json => { msg: country(params[:countryname]) } } #message for AJAX response
		end
	end

	def createPhoto
		@user = User.find_by(username: session[:username])
		#create the photo from the given attributes
		@user.photos.build(link: params[:link], location_name: params[:location_name], date: params[:date], photo_name: params[:photo_name])
		if @user.save	#if the photo was saved successfully
			respond_to do |format|
				format.json { render :json => { msg: "Posted!" } }
			end
		else
			respond_to do |format|
				format.json { render :json => { msg: "Error! This photo possibly already exists!" } }
			end
		end
	end

end
