class MatterCustomersController < ApplicationController

  layout "matters"

  before_filter :get_matter

  def index
    @matter_customers = MatterCustomer.where(:matter_id => params[:matter_id], :customer_type => params[:type].capitalize).all
  end

  def new
    @matter_customer = MatterCustomer.new(:takeover_date => Date.today)
    @matter_customer.customer_type = params[:type].to_s.capitalize
    @matter_customer.author = current_user
    @matter_customer.matter = @matter
  end

  def create
    @matter_customer = MatterCustomer.new(params[:matter_customer])
    if @matter_customer.customer_id.nil?
      @matter_customer.errors.add(:customer_name, "may not be empty")
      render 'new' and return
    end
    @matter.change_customers_from_history @matter_customer
    if @matter_customer.save
      redirect_to @matter
    else
      render 'new'
    end
  end

  def edit
    @matter_customer = MatterCustomer.find(params[:id])
  end

  def update
    @matter_customer = MatterCustomer.find(params[:id])
    if @matter_customer.update_attributes(params[:matter_customer])
      redirect_to @matter
    else
      render 'edit'
    end
  end

  def destroy
    @matter_customer = MatterCustomer.find(params[:id])
    @matter = @matter_customer.matter
    MatterCustomer.delete(@matter_customer)
    redirect_to @matter
  end

  private
  def get_matter
    @matter = Matter.find(params[:matter_id])
  end

end