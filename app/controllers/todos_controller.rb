class TodosController < ApplicationController
  def index
		user_name = params[:username] #create user from username
		@user = User.find_or_create_by(username: user_name)	#find or create the logged in user
		#@user.photos.create(link: "http://www.google.com", location_name: "France", date: "08/08/08")
		@user.photos.new(link: "http://www.google.com", location_name: "France", date: "08/08/08")
		@user.save
		@user.photos.new(link: "http://www.google.com", location_name: "Russia", date: "08/08/08")
  end
end
