class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user] = user.id
      flash[:success] = "Welcome back"
      sign_in user
      redirect_to user
    else
      flash.now[:error] = "Invalid username or password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end