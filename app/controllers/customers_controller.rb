class CustomersController < ApplicationController

  layout "customers"

  def index
    @apply_filter = true
    @customers = Customer.where(:date_effective_end => nil).paginate(:per_page => current_user.rows_per_page, :page => params[:customers_page])
  end

  def quick_search
    @apply_filter = true
    @customers = Customer.quick_search(params[:search], params[:customers_page], current_user.rows_per_page)
    render 'index'
  end

  def new
    @party = Party.new()
    @party.customer = Customer.new(:customer_type => params[:customer_type])
    @party.company = Company.new
  end

  def create
    Party.transaction do
      @party = Party.new(params[:party])
      if @party.save
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
    if params[:save]
      return update_save params
    end
    if params[:save_as]
      return update_save_as params
    end
    redirect_to edit_customer_path params[:id] and return
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def agent_find_ajax
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name ilike ? and customers.date_effective_end is null', "%#{params[:term]}%"])
    @customers.each do |customer|
      @result<<{:id => customer.orig_id, :label => customer.name, :value => customer.name, :vat_number => customer.vat_registration_number}
      index += 1
    end
    render :json => @result
  end

  def applicant_find_ajax
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name ilike ? and customers.date_effective_end is null', "%#{params[:term]}%"])
    @customers.each do |customer|
      @result<<{:id => customer.orig_id, :label => customer.name, :value => customer.name, :vat_number => customer.vat_registration_number}
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

  private

  def update_save params
    @party = Party.find(params[:party][:id])
    Party.transaction do
      if @party.update_attributes(params[:party])
        redirect_to customer_path(@party.customer)
      else
        render 'edit' and return
      end
    end
  end

  def update_save_as params
    ActiveRecord::Base.transaction do
      original = Party.find(params[:party][:id])
      @party = original.deep_dup
      original.no_longer_used
      original.customer.no_longer_used
      original.company.no_longer_used
      @party.errors.clear
      if @party.save
        params[:party][:id] = @party.id
        params[:party][:date_effective_end] = nil
        params[:party][:customer_attributes][:id]       = @party.customer.id
        params[:party][:customer_attributes][:date_effective_end] = nil
        params[:party][:customer_attributes][:party_id] = @party.customer.party_id
        params[:party][:company_attributes][:id]        = @party.company.id
        params[:party][:company_attributes][:date_effective_end] = nil
        params[:party][:company_attributes][:party_id]  = @party.company.party_id
        if @party.update_attributes(params[:party])
          @party.copy_addresses(original.active_addresses)
          @party.copy_contacts(original.contacts)
          @party.company.copy_accounts(original.company.accounts)
          redirect_to @party.customer and return
        end
      else
        swap_attributes original, @party, [:id, :party_id]
        swap_attributes original.customer, @party.customer, [:id, :party_id]
        swap_attributes original.company, @party.company, [:id, :party_id]
        render 'edit' and return
      end
      render 'edit'
    end
  end

  private
  def swap_attributes from, to, attrs = []
    attrs.each do |attr|
      to.send("#{attr}=", from.send(attr)) if to.respond_to? attr
    end
  end

end
