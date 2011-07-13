class ProfilesController < ApplicationController

  layout "profile"
  def show
    @party = current_user.individual.party
  end


  def update
    @party = User.find(current_user.id).individual.party
    User.transaction do
      if @party.update_attributes(params[:party])
        flash[:success] = t("user.success.profile.changed")
        redirect_to profile_path and return
      end
      flash.now[:error] = t("user.error.profile.change")
      render 'show' and return
    end
    render 'show' and return
  end

  def show_password
    @user = User.find(current_user.id)
    render 'show_password'
  end

  def change_password
    @user = User.find(current_user.id)
    if @user.has_password?(params[:user][:password_current])
      password_attributes = {:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation]}
      password_attributes[:change_pwd => true]      
      if @user.update_attributes(password_attributes)
        flash[:success] = t("user.success.password.changed")
        redirect_to profile_path and return
      end
    else
      flash.now[:error] = t("user.error.password.incorect")
      render 'show_password' and return      
    end
    flash.now[:error] = t("user.error.password.change")
    render 'show_password' and return
  end

end
