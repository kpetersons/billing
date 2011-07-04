class AttorneyFeeTypesController < ApplicationController

  layout "invoices"

  def index
    @attorney_fee_types = AttorneyFeeType.paginate(:page =>  params[:attorney_fee_types])
  end

  def new
    @attorney_fee_type = AttorneyFeeType.new
  end

  def create
    @attorney_fee_type = AttorneyFeeType.new(params[:attorney_fee_type])
    AttorneyFeeType.transaction do
      if @attorney_fee_type.save
        redirect_to @attorney_fee_type and return
      end
      render 'new'
    end
  end

  def edit
    @attorney_fee_type = AttorneyFeeType.find(params[:id])    
  end
  
  def update
    @attorney_fee_type = AttorneyFeeType.find(params[:id])
    AttorneyFeeType.transaction do
      if @attorney_fee_type.update_attributes(params[:attorney_fee_type])
        redirect_to @attorney_fee_type and return
      end
      render 'edit'
    end
  end  

  def show
    @attorney_fee_type = AttorneyFeeType.find(params[:id])    
  end

end
