class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # redirect_to user, notice: " login in success"
      sign_in user
      flash[:success] = "#{user.name} has login in"
      # redirect_to user
      redirect_to_location(user)
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end
  def destroy
    sign_out
    redirect_to root_path
  end
end
