class AddressesController < ApplicationController

  layout "customers"
   
  def index
    @addresses = Address.all()
  end

  def new
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @address = Address.new
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    
    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?    
    @party = @user.individual.party unless user_id.nil?     
  end

  def create
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @address = Address.new(params[:address])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    #
    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?    
    @party = @user.individual.party unless user_id.nil?    
    Address.transaction do
      unless @address.address_type_name.nil? && @address.address_type_name.empty?
        if AddressType.exists?(:name => @address.address_type_name)
          @address.address_type_id = AddressType.find_by_name(@address.address_type_name)
        else
          @address_type = AddressType.create(:name => @address.address_type_name, :party_id => @party.id, :built_in => false)
          @address.address_type_id = @address_type.id
        end
      end
      if @party.addresses<<@address
        redirect_to @path_elements  and return
      end
      render 'new' and return
    end
  end

  def edit
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @address = Address.find(params[:id])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    
    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?    
    @party = @user.individual.party unless user_id.nil?     
  end

  def update
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @address = Address.find(params[:address][:id])
    #
    @path_elements = [@customer, @individual, @user]
    Address.transaction do
      unless @address.address_type_name.nil? && @address.address_type_name.empty?
        if AddressType.exists?(:name => @address.address_type_name)
          @address.address_type_id = AddressType.find_by_name(@address.address_type_name)
        else
          @address_type = AddressType.create(:name => @address.address_type_name, :party_id => @party.id, :built_in => false)
          @address.address_type_id = @address_type.id
        end
      end      
      if @address.update_attributes(params[:address])
        redirect_to @path_elements and return
      end
      render 'edit'
    end
  end

  def show
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @address = Address.find(params[:id])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    render "show" and return
  end

end
