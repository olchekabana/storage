class SessionsController < ApplicationController
respond_to :html, :js
require 'digest/md5'
  
  def login
	user = User.find_by_login(params[:login])
	pas = Digest::MD5.hexdigest(params[:password])
	if user && user.password == pas
		session[:user_id] = 2
		#user.id_user
		respond_to do |format|
			format.js
		end
	else
		respond_to do |format|
			format.js { render :template => "sessions/error" }
		end
	end
  end
  
  def logout
	session[:user_id] = nil
	redirect_to :back
  end
  
end
