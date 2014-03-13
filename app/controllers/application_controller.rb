class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def check_auth
	  if session[:user_id] && !User.exists?(session[:user_id])
		  session[:user_id] = nil
	  end
  end
  
  def my_name
    session[:my_name] = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
  end
  
  def set_sort_schedule
    cookies[:sort_schedule] ||= 1
    
  end
end
