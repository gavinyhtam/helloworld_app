class ProfilesController < ApplicationController
  def index
		@user = User.find_by(username: cookies[:username])
		if @user.photos.size > 1
			@last_location = @user.photos.order(:date).find(1);
		end
  end
end
