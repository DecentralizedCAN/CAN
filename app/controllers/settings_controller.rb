class SettingsController < ApplicationController
  	before_action :require_login
  	before_action :require_admin

	def index
		@settings = Setting.last(10)
	end

	def turn_on
		puts "hohoho"
    	@setting = Setting.find(params[:setting_id])
    	@setting.update!(:state => true)
    	redirect_to settings_path
	end

	def turn_off
		puts "hihihi"
    	@setting = Setting.find(params[:setting_id])
    	@setting.update!(:state => false)
    	redirect_to settings_path
	end
end
