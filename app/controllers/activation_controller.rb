require "forwardable"



class ActivationController < ApplicationController

  before_filter :authenticate, :only => []

  def show
    @user = User.find_by_activation_key(params[:key])
    render 'activate'
  end

  def activate
    @user = User.find(params[:user][:id])
    if @user.active
      redirect_to root_path and return
    end
    User.transaction do
      password_attributes = {
        :password => params[:user][:password], 
        :password_confirmation => params[:user][:password_confirmation],
        :change_pwd => true,
        :active => true,
        :blocked => false
        }
      if @user.update_attributes(password_attributes)
        flash[:success] = t("user.success.password.set")
        redirect_to root_path and return
      end
      flash.now[:error] = t("user.error.password.set")
      render 'activate'
    end
  end
end
