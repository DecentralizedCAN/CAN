class SessionsController < ApplicationController
  include ActivitiesHelper
  include CommentsHelper
  include UpvoteHelper

  def new
  end

  def create
    if params[:session][:email].length == 0
      flash[:danger] = 'You must provide a name'
      redirect_to root_path
    elsif params[:session][:password].length == 0
      flash[:danger] = 'You must provide a password'
      redirect_to root_path
    else

    user = User.find_by(email: params[:session][:email].downcase)
    user = User.find_by(email: params[:session][:email]) if !user
    user = User.find_by(name: params[:session][:email].downcase) if !user
    user = User.find_by(name: params[:session][:email]) if !user
    user = User.find_by(email: params[:session][:add_email].downcase) if !user && params[:session][:add_email]
    user = User.find_by(email: params[:session][:add_email]) if !user && params[:session][:add_email]

    if user && params[:session][:password].length > 0 && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # params[:session][:remember_me] == '0' ? forget(user) : remember(user)
        remember(user)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
      end

    # if someone enters wrong information on invitation, just deal with it
    elsif user && params[:session][:commitments_json] && params[:session][:commitments_json].length > 0
      @username = params[:session][:email].downcase
      @useremail = params[:session][:add_email].downcase

      if User.find_by(:email => @useremail)
        flash[:warning] = 'The email ' + params[:session][:add_email] + ' was taken, so we could not add it to your account. If you would like to add an email, you can do so in your account settings.'
        @useremail = ''
      end

      if User.exists?(:name => @username)
        flash[:warning] = 'The username ' + params[:session][:email] + ' was taken and you did not enter the password for it, so we added a number to the end.'
        
        def find_username(attempt, i)
          if User.exists?(:name => attempt + i.to_s)
            find_username(attempt, i + 1)
          else
            @username = attempt + i.to_s
            puts @username
          end
        end

        puts "===="
        puts User.exists?(:name => @username)
        find_username(@username, 1)
        
        puts @username
        puts '----------------'
      end

      puts @username
      puts '----------------'

      @user = User.new(:name => @username, :email => @useremail, :password => params[:session][:password], :email_notifications => true,
                          :password_confirmation => params[:session][:password], :admin => String(rand(382132)), :superadmin =>  String(rand(382130)))
      @user.save
      @user.activate
      log_in @user
      remember(@user)

    elsif user
      flash[:warning] = "That user already exists and this is not the correct password. If you're signing up for the first time, try using a different name."

    elsif Setting.find(6).state

      @user = User.new(:name => params[:session][:email].downcase, :email => params[:session][:add_email].downcase, :password => params[:session][:password], :email_notifications => true,
                          :password_confirmation => params[:session][:password], :admin => String(rand(382132)), :superadmin =>  String(rand(382130)))
      @user.save
      @user.activate
      # flash[:success] = 'Welcome to ' + ENV['GROUP_NAME'] + ', ' + @user.name + '!'
      log_in @user
      remember(@user)
    end

    if params[:session][:commitments_json] && params[:session][:commitments_json].length > 0
      puts "--------"
      puts params[:session][:commitments_json]
      puts"========="

      commitments = JSON.parse(params[:session][:commitments_json])

      commitments.each do |role_id|
        commit_to_a_role(role_id)
      end

      flash[:success] = "Thanks for your participation!"
      redirect_to action_path(:activity_id => Roll.find(commitments[0]).activity.hashid)
    elsif Setting.find(6).state
      redirect_back fallback_location: root_path
    else
      redirect_to root_path
    end

    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end