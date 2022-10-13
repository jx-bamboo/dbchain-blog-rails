class ApplicationController < ActionController::Base
  def sms_code(num)
	  chars = ("0".."9").to_a
	  code = ""
	  1.upto(num){code << chars[rand(chars.length-1)]}
	  code
	end

  def current_user
    session[:user]
  end
end
