class UsersController < ApplicationController

  layout "administration"
  def index
    @users = User.paginate(:per_page => current_user.rows_per_page, :page =>  params[:page])
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
        @user = @party.individual.user        
        @user.update_attributes(:active => false, :blocked => false, :registration_date => Date.today)
        Contact.create(:party_id => @party.id, :contact_type_id => ContactType.find_by_name("CT_E-MAIL").id, :contact_value => @party.individual.user.email)
        ActivationMailer.activation_email(@user).deliver        
        redirect_to user_path(@user)
      else
        render 'new'
      end
    end
  end

  def edit
    @party = User.find(params[:id]).individual.party
  end

  def update
    Party.transaction do
      @party = User.find(params[:id]).individual.party
      if @party.update_attributes(params[:party])
        redirect_to user_path(@user)
      else
        render 'new'
      end
    end    
  end

  def show
    @user = User.find(params[:id])
  end

  def activate
    User.transaction do
      @user = User.find_by_id(params[:id])
      if current_user.has_function(:name => 'funct.activate.user') 
        if @user.update_attribute(:active, !@user.active)
          redirect_to (user_path @user) and return
        else
          flash.now[:error] = "Could not #{(@user.active)? 'de':''}block user #{@user.individual.first_name} #{@user.individual.last_name}"
          render 'show' and return          
        end
      else
        flash.now[:error] = "You do not have permissions to perform this operation"
        render 'show' and return
      end
    end
  end

  def block
    User.transaction do
      @user = User.find_by_id(params[:id])
      if current_user.has_function(:name => 'funct.block.user') 
        if @user.update_attribute(:blocked, !@user.blocked)
          redirect_to (user_path @user) and return
        else
          flash.now[:error] = "Could not #{(@user.blocked)? 'un':''}block user #{@user.individual.first_name} #{@user.individual.last_name}"
          render 'show' and return
        end
      else
        flash.now[:error] = "You do not have permissions to perform this operation"
        render 'show' and return
      end
    end
  end

end
