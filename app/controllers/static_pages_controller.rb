class StaticPagesController < ApplicationController
 skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  	#default empty page handlers for static pages
  def home
  end

  def about
  end

  def help
  end
    
  def login
   #if new user
	if (!User.find_by(fb_id: params[:fb_id]))
		cookies[:new_user] = true
	end
	#create user
    User.create(username: params[:username], first_name: params[:first_name], 
					last_name: params[:last_name], fb_id: params[:fb_id], profile_pic_link: params[:profile_pic_link])
	#save FB id in cookies
    cookies[:fb_id] = params[:fb_id]
    respond_to do |format|
       format.json { render :json => { msg: "Logging in..." } }
	 end
  end
end
