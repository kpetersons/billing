class IndividualsController < ApplicationController

  layout "customers"
  def index

  end

  def choose
    @customer = Customer.find(params[:customer_id])
    @contact_persons = Individual.all
    @relationship = Relationship.new(:relationship_type_id => RelationshipType.find_by_name('CONTACT_PERSON').id, :source_party_id => @customer.party_id)
  end

  def add
    @customer = Customer.find(params[:customer_id])
    Relationship.transaction do
      @relationship = Relationship.create(params[:relationship])
      if @relationship.persisted?
        redirect_to customer_path(@customer)
       else
         redirect_to choose_customer_contact_persons_path(@customer)
      end
    end
  end

  def new
    @party = Customer.find(params[:customer_id]).party
    @contact_person = Party.new
    @contact_person.individual = Individual.new
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
    @contact_person = Individual.find(params[:id]).party
  end

  def update
    @party = Individual.find(params[:id]).party
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
    @contact_person = Individual.find(params[:id])
  end

end
