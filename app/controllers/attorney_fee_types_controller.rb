class AttorneyFeeTypesController < ApplicationController

  layout "invoices"

  def index
    @attorney_fee_types = AttorneyFeeType.paginate(
        :per_page => current_user.rows_per_page,
        :page =>  params[:attorney_fee_types],
        :conditions => (current_user.has_function :name => "funct.view.all.fee.types")? nil : ["operating_party_id = #{current_user.operating_party_id}"])
  end

  def new
    @attorney_fee_type = AttorneyFeeType.new(:operating_party_id => current_user.operating_party_id)
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
