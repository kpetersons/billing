class CustomersController < ApplicationController

  layout "customers"
  
  def index
    @customers = Customer.paginate(:page =>  params[:customers_page])
  end

  def new
    @party = Party.new()
    @party.customer = Customer.new(:customer_type => params[:customer_type])
    @party.company = Company.new
  end

  def create
    Party.transaction do
      @party = Party.create(params[:party])
      if @party.persisted?
        redirect_to customer_path(@party.customer)
      else
        @customer = @party.customer
        render 'new'
      end
    end
  end

  def edit
    @party = Customer.find(params[:id]).party
  end

  def update
    @party = Party.find(params[:party][:id])
    Party.transaction do
      if @party.update_attributes(params[:party])
        redirect_to customer_path(@party.customer)
      else
        render 'edit'
      end
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def agent_find_ajax
    @result = Hash.new
    @result[:query] =  params[:query]
    @result[:suggestions] = Array.new
    @result[:data] = Array.new
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ?', "%#{params[:query]}%"])
    @customers.each do |customer|
      @result[:suggestions][index] = customer.name
      @result[:data][index] = customer.id
      index += 1
    end
    render :json => @result
  end

  def applicant_find_ajax
    @result = Hash.new
    @result[:query] =  params[:query]
    @result[:suggestions] = Array.new
    @result[:data] = Array.new
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ?', "%#{params[:query]}%"])
    @customers.each do |customer|
      @result[:suggestions][index] = customer.name
      @result[:data][index] = customer.id
      index += 1
    end
    render :json => @result
  end  

end
