class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def check_auth
	if session[:user_id] && !User.exists?(session[:user_id])
		session[:user_id] = nil
	end
  end
end
