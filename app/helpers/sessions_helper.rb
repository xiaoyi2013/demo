module SessionsHelper
  def sign_in(user)
    # cookies.permanent[:user_id] = user.id
    # session[:current_user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
  def current_user
    # @current_user ||= cookies[:user_id] && User.find(cookies[:user_id])
    # @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
    @current_user ||= cookies[:remember_token] && User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
    unless sign_in?
      store_location
      redirect_to signin_path, notice: "Please sign in" 
    end
    # redirect_to signin_path, notice: "Please sign in" unless sign_in?
  end
  
  def sign_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    # cookies.delete(:user_id)
    # session[:current_user_id] = nil
    cookies.delete(:remember_token)
  end

  def store_location
    session[:location] = request.fullpath
  end
  
  def redirect_to_location(default)
    redirect_to (session[:location] || default)
    session.delete(:location)
  end
end
