class SessionsController < ApplicationController

  before_filter :authenticate, :only => [:destroy]
  
  def new
    unless current_user.nil?
      redirect_to customers_path
    end
  end

  def signin
    @yield_title = 'Sign in'
    user = User.authenticate(params[:session][:email],
    params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    else
      sign_in user
      redirect_back_or customers_path
    end
  end

  def signout
    sign_out
    redirect_to root_path
  end
end
