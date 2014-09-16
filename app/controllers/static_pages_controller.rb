class StaticPagesController < ApplicationController
 skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  def home
  end

  def about
  end

  def help
  end
    
  def login
    User.create(username: params[:username], first_name: params[:first_name], 
					last_name: params[:last_name], fb_id: params[:fb_id])
    session[:username] = params[:username]
    respond_to do |format|
       format.json { render :json => { msg: "Logging in..." } }
	 end
  end
end
