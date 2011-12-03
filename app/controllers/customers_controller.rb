class CustomersController < ApplicationController

  layout "customers"

  def index
    @apply_filter = true
    @customers = Customer.where(:date_effective_end => nil).paginate(:page => params[:customers_page])
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
      @party = Party.new(params[:party])
      if @party.save
        @date_effective =DateTime.now

        @party.update_attribute(:orig_id, @party.id)
        @party.company.update_attribute(:orig_id, @party.company.id)
        @party.customer.update_attribute(:orig_id, @party.customer.id)

        @party.update_attribute(:date_effective, @date_effective)
        @party.company.update_attribute(:date_effective, @date_effective)
        @party.customer.update_attribute(:date_effective, @date_effective)

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
      shortnote = params[:party][:customer_attributes][:shortnote]
      params[:party][:customer_attributes].reject!{|x| x.eql?("shortnote")}
      @test = Party.find(params[:party][:id])
      @test.attributes = params[:party]
      unless @test.changed? || @test.customer.changed? || @test.company.changed?
        params[:party][:customer_attributes][:shortnote] = shortnote
        if @test.update_attributes(params[:party])
          redirect_to customer_path(@test.customer) and return
        else
          @party = @test
          render 'edit' and return
        end
      end

      @date_effective =DateTime.now
      @party.customer.update_attribute(:date_effective_end, @date_effective)
      @party.company.update_attribute(:date_effective_end, @date_effective)
      @party.update_attribute(:date_effective_end, @date_effective)

      if @party.customer.version.nil?
        @party.customer.update_attribute(:version, 1)
      end
      params_copy = params.reject { |x| false }
      params_copy[:party].reject! { |x| x.eql?("id") }
      params_copy[:party][:company_attributes].reject! { |x| x.eql?("id") }
      params_copy[:party][:customer_attributes].reject! { |x| x.eql?("id") }

      @party_new = Party.new(params[:party])
      @party_new.orig_id = @party.orig_id || @party.id
      @party_new.version = @party.version + 1
      @party_new.date_effective = @date_effective

      @party_new.customer.orig_id = @party.customer.orig_id || @party.customer.id
      @party_new.customer.version = @party.customer.version + 1
      @party_new.customer.date_effective = @date_effective

      @party_new.company.orig_id = @party.company.orig_id || @party.company.id
      @party_new.company.version = @party.company.version + 1
      @party_new.company.date_effective = @date_effective

      if @party_new.save
        @party.active_addresses.each do |address|
          new_address = address.clone
          new_address.orig_id = address.orig_id || address.id
          new_address.version = address.version + 1
          new_address.date_effective = @date_effective
          @party_new.addresses<<new_address
          address.update_attribute(:date_effective_end, @date_effective)
        end
        redirect_to customer_path(@party_new.customer) and return
      else
        @customer = @party_new.customer
      end
    end
    @party = @party_new
    render 'new'
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def agent_find_ajax
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ? and customers.date_effective_end is null', "%#{params[:term]}%"])
    @customers.each do |customer|
      @result<<{:id => customer.id, :label => customer.name, :value => customer.name, :vat_number => customer.vat_registration_number}
      index += 1
    end
    render :json => @result
  end

  def applicant_find_ajax
    @result = []
    index = 0
    @customers = Customer.joins(:party => :company).all(:conditions => ['name like ? and customers.date_effective_end is null', "%#{params[:term]}%"])
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

  private

  def update_save

  end

  def update_save_as

  end

end
