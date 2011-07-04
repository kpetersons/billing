class ContactPersonsController < ApplicationController

  layout "customers"

  def index

  end

  def new
    @party = Customer.find(params[:customer_id]).party
    @contact_person = Party.new
    @contact_person.contact_person = ContactPerson.new
  end

  def create
    @party = Customer.find(params[:customer_id]).party
    Party.transaction do 
      @contact_person = Party.create(params[:party])
      if @contact_person.persisted?
        Relationship.create(:relationship_type_id => RelationshipType.find_by_name('CONTACT_PERSON').id, :source_party_id => @party.id, :target_party_id => @contact_person.id)
        redirect_to customer_path(@party.customer)
      else        
        render 'new'
      end
    end    
  end
  
  def edit
    @party = Customer.find(params[:customer_id]).party
    @contact_person = ContactPerson.find(params[:id]).party
  end

  def update
    @party = ContactPerson.find(params[:id]).party
    @customer = Customer.find(params[:customer_id])
    Party.transaction do
      if @party.update_attributes(params[:party])
        redirect_to customer_path(@customer)
      else
        render 'edit'
      end
    end    
  end

  def show
    @customer = Customer.find(params[:customer_id])
    @contact_person = ContactPerson.find(params[:id])
  end

end
