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
    @party = @operating_party.company.party  unless operating_party_id.nil?
  end

  def create
    @address = Address.new(params[:address])    
       
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
    @party = @operating_party.company.party  unless operating_party_id.nil?
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
        redirect_to @path_elements  and return
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
    @party = @operating_party.company.party  unless operating_party_id.nil?
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
    @party = @operating_party.company.party  unless operating_party_id.nil?
    @address = Address.find(params[:address][:id])
    #
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
      if @address.update_attributes(params[:address])
        redirect_to @path_elements and return
      end
      render 'edit'
    end
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
    @party = @operating_party.company.party  unless operating_party_id.nil?
    render "show" and return
  end

end
