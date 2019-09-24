class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

	# before_action :require_login

	private

	  def require_login
	    unless current_user
	      redirect_to login_url
	    end
	  end

    def check_activity
      if current_user.last_posted && Time.now - current_user.last_posted < 100
        redirect_to root_path, notice: 'Please wait a minute and try again'
      end
    end
end
