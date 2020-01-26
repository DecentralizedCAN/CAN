class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    if Setting.find(3).state || (current_user && current_user.admin?)
      @user = User.new      
    else
      flash[:info] = "The admin has disallowed user signup."
      redirect_to login_path
    end
  end

  # GET /users/add
  def add
    if Setting.find(3).state || (current_user && current_user.admin?)
      @user = User.new      
    else
      flash[:info] = "Only admins can view this page."
      redirect_to login_path
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # def update_settings
  #   @user.update(:email_notifications => params[:email_notifications])
  #   redirect_to @user
  # end

  # POST /users
  def create
    @user = User.new(user_params)
    if current_user.admin?
      @user.activated = true
      if @user.save
        flash[:info] = "User created."
        redirect_to root_url
      end
    elsif @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def resend_activation
    user = User.find_by(email: params[:session][:email].downcase)
    user.send_activation_email
  end

  def instant_activation
    user = User.find(params[:id])
    activation_token = User.new_token
    user.activation_token  = activation_token
    user.activation_digest = User.digest(activation_token)
    if user.save
      user.send_activation_email
      flash[:info] = "Sent email successfully"
      redirect_to user
    else
      flash[:info] = "Couldn't send email"
      redirect_to user
    end
  end

  def make_admin
    user = User.find(params[:id])
    if current_user.admin?
      user.admin = true
      if user.save
        flash[:info] = "This user is now an admin"
        redirect_to user
      else
        flash[:info] = "Couldn't give this user admin privileges"
        redirect_to user
      end
    end
  end

  def remove_admin
    user = User.find(params[:id])
    if current_user.admin?
      user.admin = false
      if user.save && user.email != ENV['ADMIN_EMAIL']
        flash[:info] = "This user is no longer an admin"
        redirect_to user
      else
        flash[:info] = "Couldn't remove admin privileges from this user"
        redirect_to user
      end
    end
  end

    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    #   log_in user
    #   params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    #   redirect_back_or user
    # else
    #   flash.now[:danger] = 'Invalid email/password combination'
    #   render 'new'
    # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    if current_user.admin?
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :email_notifications,
                                   :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
