class OfficialFeeTypesController < ApplicationController
  layout "invoices"

  def index
    @official_fee_types = OfficialFeeType.paginate(:page =>  params[:official_fee_types], :conditions => ["operating_party_id = #{current_user.operating_party_id}"])
  end

  def new
    @official_fee_type = OfficialFeeType.new(:operating_party_id => current_user.operating_party_id)
  end

  def create
    @official_fee_type = OfficialFeeType.new(params[:official_fee_type])
    OfficialFeeType.transaction do
      if @official_fee_type.save
        redirect_to @official_fee_type and return
      end
      render 'new'
    end
  end

  def edit
    @official_fee_type = OfficialFeeType.find(params[:id])    
  end
  
  def update
    @official_fee_type = OfficialFeeType.find(params[:id])
    OfficialFeeType.transaction do
      if @official_fee_type.update_attributes(params[:official_fee_type])
        redirect_to @official_fee_type and return
      end
      render 'edit'
    end
  end  

  def show
    @official_fee_type = OfficialFeeType.find(params[:id])    
  end
end
