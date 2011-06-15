class AddressesController < ApplicationController

  layout "customers"

  def index
    @addresses = Address.all()
  end

  def new
    @address = Address.new
    @party  = Party.find(params[:party_id])
  end

  def create
    @party = Party.find(params[:party_id])
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
    @address = Address.find(params[:id])
    @party = Party.find(params[:party_id])
  end
  
  def update
    @party = Party.find(params[:party_id])    
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
    @address = Address.find(params[:id])
    @party = Party.find(params[:party_id])    
  end

end
