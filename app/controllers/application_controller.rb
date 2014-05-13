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
    cookies[:sort_stages] ||= 1
    cookies[:sort_tasks] ||= 1
  end
  
  def set_switch
    session[:switch] ||= 'hide'
  end
  
  def unuthed
    unless session[:user_id]
      redirect_to contracts_path
    end
  end
end
