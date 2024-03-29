class RolesController < ApplicationController
  
  layout "administration"  
  
  def index
    @roles = Role.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
  end

  def choose
    @user = User.find(params[:user_id])
    @roles = Role.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
    @user_role = UserRole.new(:user_id => @user.id)
  end
  
  def add
    @user = User.find(params[:user_id])
    @user_role = UserRole.new(params[:user_role])
    Role.transaction do
      if @user.user_roles<<@user_role
        redirect_to @user
      else
        @roles = Role.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
        render 'choose' 
      end
    end    
  end

  def remove
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    @user.roles.delete(@role)
    redirect_to user_path(@user, :anchor => "roles")
  end

  def new
    @role = Role.new  
  end

  def create
    @role = Role.new(params[:role])
    Role.transaction do
      if @role.save
        redirect_to @role
      else
        render 'new'
      end
    end    
  end

  def edit
    @role = Role.find(params[:id])
  end

  def show
    @role = Role.find(params[:id])
  end

end
