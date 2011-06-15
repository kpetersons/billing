class FunctionsController < ApplicationController

  layout "administration"

  def index
    @functions = Function.paginate(:page =>  params[:page], :per_page => 10)
  end

  def choose
    @role = Role.find(params[:role_id])
    @functions = Function.paginate(:page =>  params[:page], :per_page => 10)
    @role_function = RoleFunction.new(:role_id => @role.id)
  end
  
  def add
    @role = Role.find(params[:role_id])
    @role_function = RoleFunction.new(params[:role_function])
    Function.transaction do
      if @role.role_functions<<@role_function
        redirect_to @role
      else
        @functions = Function.paginate(:page =>  params[:page], :per_page => 10)
        render 'choose' 
      end
    end    
  end

  def show
    @function = Function.find(params[:id])
  end

end
