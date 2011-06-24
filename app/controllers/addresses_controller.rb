class AddressesController < ApplicationController

  layout "customers"  

  def index
    @addresses = Address.all()
  end

  def new
    party_id = params[:party_id] || params[:contact_person_id]    
    @address = Address.new
    @party  = Party.find(party_id)
  end

  def create
    party_id = params[:party_id] || params[:contact_person_id]
    @party = Party.find(party_id)
    @address = Address.new(params[:address])    
    Address.transaction do
      if @party.addresses<<@address 
        redirect_to @party.outer_object
      else
        render 'new'
      end
    end
  end

  def edit
    party_id = params[:party_id] || params[:contact_person_id]    
    @address = Address.find(params[:id])
    @party = Party.find(party_id)
  end
  
  def update
    party_id = params[:party_id] || params[:contact_person_id]    
    @party = Party.find(party_id)    
    @address = Address.find(params[:address][:id])
    Address.transaction do
      if @address.update_attributes(params[:address])        
        redirect_to @party.outer_object
      else
        render 'edit'
      end
    end    
  end

  def show
    party_id = params[:party_id] || params[:contact_person_id]    
    @address = Address.find(params[:id])
    @party = Party.find(party_id)    
  end

end
