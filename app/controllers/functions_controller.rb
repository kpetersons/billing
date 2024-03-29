class FunctionsController < ApplicationController

  layout "administration"

  def index
    @functions = Function.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
  end

  def choose
    @role = Role.find(params[:role_id])
    @functions = Function.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
    @role_function = RoleFunction.new(:role_id => @role.id)
  end
  
  def add
    @role = Role.find(params[:role_id])
    @role_function = RoleFunction.new(params[:role_function])
    Function.transaction do
      if @role.role_functions<<@role_function
        redirect_to @role
      else
        @functions = Function.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
        render 'choose' 
      end
    end    
  end

  def remove
    @role = Role.find(params[:role_id])
    @function = Function.find(params[:id])
    @role.functions.delete(@function)
    redirect_to role_path(@role, :anchor => "functions")
  end

  def show
    @function = Function.find(params[:id])
  end

end
