class ContactsController < ApplicationController
  
  layout "customers"

  def index
    @contacts = Contact.all()
  end

  def new
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @contact = Contact.new
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
  end

  def create
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @contact = Contact.new(params[:contact])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    #
    @party = @customer.party unless customer_id.nil?
    @party = @individual.party unless individual_id.nil?    
    @party = @user.individual.party unless user_id.nil?    
    Contact.transaction do
      if @party.contacts<<@contact
        redirect_to @path_elements  and return
      end
      render 'new' and return
    end    
    
    @party = Party.find(params[:party_id])
    @contact = Contact.new(params[:contact])    
    Contact.transaction do
      if @party.contacts<<@contact
        outer_obj = @party.outer_object        
        redirect_to [@party, outer_obj]
      else
        render 'new'
      end
    end
  end

  def edit
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @contact = Contact.find(params[:id])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]    
    
  end
  
  def update
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?
    @contact = Contact.find(params[:contact][:id])
    #
    @path_elements = [@customer, @individual, @user]
    Contact.transaction do
      if @contact.update_attributes(params[:contact])
        redirect_to @path_elements and return
      end
      render 'edit'
    end    
  end

  def show
    customer_id = params[:customer_id]
    individual_id = params[:contact_person_id]
    user_id = params[:user_id]
    @contact = Contact.find(params[:id])
    @customer = Customer.find(customer_id) unless customer_id.nil?
    @individual = ContactPerson.find(individual_id) unless individual_id.nil?
    @user = User.find(user_id) unless user_id.nil?    
    @path_elements = [@customer, @individual, @user]
    render "show" and return    
  end

end
