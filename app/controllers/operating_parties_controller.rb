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
    @party = OperatingParty.find(params[:id]).company.party
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

  def choose_matter_type
    @operating_party = OperatingParty.find(params[:id])
    @operating_party_matter_type = OperatingPartyMatterType.new(:operating_party_id => @operating_party.id)
    @matter_types = MatterType.paginate(:page =>  params[:matter_type])
    render 'matters/types/choose'
  end

  def add_matter_type
    OperatingPartyMatterType.transaction do
      @operating_party = OperatingParty.find(params[:id])
      @operating_party_matter_type = OperatingPartyMatterType.new(params[:operating_party_matter_type])
      if @operating_party_matter_type.save
        redirect_to @operating_party
      else
        flash[:error] = :could_not_add_matter_type
        redirect_to choose_matter_type_operating_party_path(@operating_party)
      end
    end
  end

end
