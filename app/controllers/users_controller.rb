class UsersController < ApplicationController
  before_action :set_user, only: [:update, :edit, :show]
  before_action :signed_in_user, only: [:update, :edit, :index]
  before_action :authorized_user, only: [:update, :edit]
  before_action :admin_user, only: [:destroy]
  before_action :admin_self, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if update_successful
      flash[:success] = "You have updated your profile information."
      redirect_to @user
    else
      flash.now[:alert] = @user.errors
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_successful
    @user && @user.update_attributes(user_params)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def authorized_user
    redirect_to root_url unless current_user?(target_user)
  end

  def target_user
    User.find(params[:id])
  end

  def set_user
    @user = target_user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def admin_self
    redirect_to(root_url) if current_user == target_user
  end
end
