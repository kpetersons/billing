class OperatingPartiesController < ApplicationController

  layout "administration"
  def index
    @operating_parties = OperatingParty.paginate(:page =>  params[:operating_parties_page])
  end

  def new
    @party = Party.new()
    @party.company = Company.new
    @party.company.operating_party = OperatingParty.new
  end

  def create
    Party.transaction do
      @party = Party.create(params[:party])
      if @party.persisted?
        redirect_to operating_party_path(@party.company.operating_party)
      else
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
      if @party.update_attributes(params[:party])
        redirect_to operating_party_path(@party.company.operating_party)
      else
        render 'edit'
      end
    end
  end

  def show
    @operating_party = OperatingParty.find(params[:id])    
  end

end
