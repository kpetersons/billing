class UsersController < ApplicationController

  layout "administration"

  def index
    @users = User.paginate(:page =>  params[:page], :per_page => 10)
  end

  def new
    @party = Party.new()
    @party.individual = Individual.new
    @party.individual.user = User.new
  end
  
  def create
    Party.transaction do
      @party = Party.new(params[:party])
      if @party.save
        Contact.create(:party_id => @party.id, :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id, :contact_value => @party.individual.user.email)        
        redirect_to user_path(@party.individual.user)
      else
        render 'new'
      end
    end
  end

  def edit
    @party = User.find(params[:id]).individual.party
  end

  def show
    @user = User.find(params[:id]) 
  end

end
