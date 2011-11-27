class AddressesController < ApplicationController

  layout "customers"

  def index
    @addresses = Address.all()
  end

  def new
    @address = Address.new

    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    operating_party_id = params[:operating_party_id]

    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @operating_party = OperatingParty.find(operating_party_id) unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]

    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?
    @party = @user.individual.party unless user_id.nil?
    @party = @operating_party.company.party unless operating_party_id.nil?
  end

  def create
    @address = Address.new(params[:address])
    @address.version = 1
    @address.date_effective = DateTime.now

    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    operating_party_id = params[:operating_party_id]

    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @operating_party = OperatingParty.find(operating_party_id) unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]

    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?
    @party = @user.individual.party unless user_id.nil?
    @party = @operating_party.company.party unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]
    Address.transaction do
      unless @address.address_type_name.empty?
        if AddressType.exists?(:name => @address.address_type_name)
          @address.address_type_id = AddressType.find_by_name(@address.address_type_name)
        else
          @address_type = AddressType.create(:name => @address.address_type_name, :party_id => @party.id, :built_in => false)
          @address.address_type_id = @address_type.id
        end
      end
      if @party.addresses<<@address
        @address.update_attribute(:orig_id, @address.id)
        redirect_to @path_elements and return
      end
      render 'new' and return
    end
  end

  def edit
    @address = Address.find(params[:id])

    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    operating_party_id = params[:operating_party_id]

    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @operating_party = OperatingParty.find(operating_party_id) unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]

    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?
    @party = @user.individual.party unless user_id.nil?
    @party = @operating_party.company.party unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]
  end

  def update
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    operating_party_id = params[:operating_party_id]

    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @operating_party = OperatingParty.find(operating_party_id) unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]

    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?
    @party = @user.individual.party unless user_id.nil?
    @party = @operating_party.company.party unless operating_party_id.nil?
    @address = Address.find(params[:address][:id])
    #
    @path_elements = [@customer, @individual, @user, @operating_party]

    @test = Address.find(params[:address][:id])
    @test.attributes = params[:address]
    unless @test.changed?
      redirect_to @path_elements and return
    end

    Address.transaction do
      unless @address.address_type_name.nil? || @address.address_type_name.empty?
        if AddressType.exists?(:name => @address.address_type_name)
          @address.address_type_id = AddressType.find_by_name(@address.address_type_name)
        else
          @address_type = AddressType.create(:name => @address.address_type_name, :party_id => @party.id, :built_in => false)
          @address.address_type_id = @address_type.id
        end
      end

      @address.update_attribute(:date_effective_end, DateTime.now)
      if @address.version.nil?
        @address.update_attribute(:version, 1)
      end

      @address_new = Address.new(params[:address].reject{|x| x.eql?(:id)})
      @address_new.orig_id = @address.orig_id || @address.id
      @address_new.version = @address.version + 1
      @address_new.date_effective = @address.date_effective_end

      if @party.addresses<<@address_new
        redirect_to @path_elements and return
      end
    end
    render 'edit'
  end

  def show
    @address = Address.find(params[:id])

    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    operating_party_id = params[:operating_party_id]

    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @operating_party = OperatingParty.find(operating_party_id) unless operating_party_id.nil?
    @path_elements = [@customer, @individual, @user, @operating_party]

    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?
    @party = @user.individual.party unless user_id.nil?
    @party = @operating_party.company.party unless operating_party_id.nil?
    render "show" and return
  end

end
