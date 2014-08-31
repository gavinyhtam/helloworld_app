class TodosController < ApplicationController
  def index
		user_name = params[:username] #create user from username
		@user = User.find_or_create_by(username: user_name)	#find or create the logged in user
		@locations = ["FR","US"]
  end
end
