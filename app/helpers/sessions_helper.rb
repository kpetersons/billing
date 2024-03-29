module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    User.switch_login_dates user
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate
    @time_left = (session[:expires_at].to_f - Time.now.to_f)
    unless @time_left > 0
      reset_session
      flash[:error] = 'Session expired.'
      sign_out
      redirect_to new_session_path and return
    end
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    flash["error"] = "Please sign in to access this page."
    redirect_to new_session_path
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
