class TodosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	include LocationCode
  def index
		user_name = params[:username] #create user from username
		@user = User.find_or_create_by(username: user_name)	#find or create the logged in user
		#sample creation of photos
		@user.photos.new(link: "http://www.google.com", location_name: "Singapore", date: "08/08/08")
		@user.save
		@user.photos.new(link: "http://www.google.com", location_name: "South Korea", date: "08/08/08")
		@user.save
=begin
		@location = params[:countryname]
		respond_to do |format|
			if (@location != nil)
				format.js { render action: cname }
			end
		end
		#@location = params[:country]
		begin
			@user = User.find_by(username: user_name)	#find or create the logged in user
		rescue ActiveRecord::RecordNotFound
			@new_user = true
			@user = User.create(username: user_name)
			@user.photos.new(link: "http://www.google.com", location_name: "France", date: "08/08/08")
			@user.save
			@user.photos.new(link: "http://www.google.com", location_name: "Russia", date: "08/08/08")
			@user.save
		end
=end
  end
	
	def create
		respond_to do |format|
			format.json { render :json => { msg: country(params[:countryname]) } } #message for AJAX response
		end
	end
end
