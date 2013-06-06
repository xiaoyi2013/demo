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

  def sign_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    # cookies.delete(:user_id)
    # session[:current_user_id] = nil
    cookies.delete(:remember_token)
  end
end
