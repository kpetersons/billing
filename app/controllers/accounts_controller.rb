class AccountsController < ApplicationController

  layout :accounts_layout

  def index
    @accounts = Account.all
  end

  def new
    @accounts = Account.new
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to @account.company.customer and return unless @account.company.customer.nil?
      redirect_to @account.company.operating_party and return
    else
      render 'new'
    end
  end

  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to @account.company.customer and return unless @account.company.customer.nil?
      redirect_to @account.company.operating_party and return
    else
      render 'edit'
    end    
  end

  def show
    @accounts = Account.new    
  end

  private 
  def accounts_layout
    unless params[:customer_id].nil?
      return 'customers'
    end
    return 'administration'
  end

end
