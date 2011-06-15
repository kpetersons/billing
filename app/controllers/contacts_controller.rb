class ContactsController < ApplicationController
  
  layout "customers"

  def index
    @contacts = Contact.all()
  end

  def new
    @contact = Contact.new
    @party  = Party.find(params[:party_id])
  end

  def create
    @party = Party.find(params[:party_id])
    @contact = Contact.new(params[:contact])    
    Contact.transaction do
      if @party.contacts<<@contact
        redirect_to @party.outer_object
      else
        render 'new'
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    @party = Party.find(params[:party_id])
  end
  
  def update
    @party = Party.find(params[:party_id])    
    @contact = Contact.find(params[:contact][:id])
    Contact.transaction do
      if @contact.update_attributes(params[:contact])
        redirect_to @party.outer_object
      else
        render 'edit'
      end
    end    
  end

  def show
    @contact = Contact.find(params[:id])
    @party = Party.find(params[:party_id])    
  end

end
