class CustomersController < ApplicationController

  layout "customers"

  def index
    @apply_filter = true
    @customers = Customer.paginate(:page => params[:customers_page])
  end

  def quick_search
    @apply_filter = true
    @customers = Customer.quick_search(params[:search], params[:customers_page])
    render 'index'
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
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ?', "%#{params[:term]}%"])
    @customers.each do |customer|
      @result<<{:id => customer.id, :label => customer.name, :value => customer.name, :vat_number => customer.vat_registration_number}
      index += 1
    end
    render :json => @result
  end

  def applicant_find_ajax
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ?', "%#{params[:term]}%"])
    @customers.each do |customer|
      @result<<{:id => customer.id, :label => customer.name, :value => customer.name, :vat_number => customer.vat_registration_number}
      index += 1
    end
    render :json => @result
  end

  def list_addresses
    @result = Customer.find(params[:customer]).addresses.collect { |tt| [tt.id, tt.name] }
    render :json => @result
  end

  def list_contact_persons
    @result = Customer.find(params[:customer]).contact_persons.collect { |tt| [tt.id, tt.name] }
    @result.unshift(['', ''])
    render :json => @result
  end

end
