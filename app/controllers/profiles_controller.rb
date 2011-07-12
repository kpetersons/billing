class ProfilesController < ApplicationController

  layout "profile"

  def show
    @party = current_user.individual.party 
  end

  def edit
    User.transaction do
    @party = User.find(current_user.id).individual.party
      if @party.update_attributes(params[:party])
        flash[:success] = t("user.success.profile.changed")
        redirect_to profile_path and return
      end
      flash.now[:error] = t("user.error.profile.changed")      
      render 'show' and return
    end
  end

  def change_password
    @user = User.find(current_user.id)
    password_attributes = {:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation]}
    if @user.update_attributes(password_attributes)
      flash[:success] = "user.success.password.changed"
      redirect_to profile_path and return
    end
    flash[:error] = "user.error.password.changed"
    redirect_to profile_path and return    
  end

end
