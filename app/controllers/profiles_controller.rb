class ProfilesController < ApplicationController

  layout "profile"

  def show
    @party = current_user.individual.party
    @preferences = current_user.preferences
  end


  def update
    @preferences = current_user.preferences
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

  def settings
    @party = User.find(current_user.id).individual.party
    @preferences = UserPreferences.find_by_user_id(current_user.id)
    UserPreferences.transaction do
      if @preferences.nil?
        @preferences = UserPreferences.new(params[:user_preferences])
        current_user.user_preferences = @preferences
        if @preferences.save()
          flash[:success] = "Preferences updated"
          redirect_to profile_path and return
        else
          flash.now[:error] = "Could not save preferences"
          render 'show' and return
        end
      else
        if @preferences.update_attributes(params[:user_preferences])
          flash[:success] = "Preferences updated"
          redirect_to profile_path and return
        else
          flash.now[:error] = "Could not save preferences"
          render 'show' and return
        end
      end
      render 'show' and return
    end
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
