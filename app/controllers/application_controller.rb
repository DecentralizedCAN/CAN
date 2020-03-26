class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

	# before_action :require_login

	private

	  def require_login
	    unless current_user

	    	if Setting.find(6).state
        	flash[:warning] = "You must sign in to do that"
    			redirect_back fallback_location: root_path
	    	else
		      redirect_to login_url
	    	end
	    end
	  end

	  def require_admin
	  	unless current_user && current_user.admin?
	      redirect_to root_url
	  	end
	  end

	  def require_admin_or_anarchy
	  	unless Setting.first.state || (current_user && current_user.admin?)
	      redirect_to root_url
	  	end
	  end

    def check_activity
		if Setting.find(2).state
			if current_user.last_posted && Time.now - current_user.last_posted < 100
				redirect_to root_path, notice: 'Please wait a minute and try again'
			end
		end
    end
end
