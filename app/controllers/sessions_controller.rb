class SessionsController < ApplicationController
  before_filter :signed_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or(user)
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
  def signed_in
    redirect_to root_path if signed_in?
  end
end
