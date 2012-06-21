class BillingSettingsController < ApplicationController

  layout "administration"

  def index
    @vat_rates = BillingSetting.paginate(
        :per_page => current_user.rows_per_page,
        :page =>  params[:vat_rates])
  end

  def new
    @vat_rate = BillingSetting.new()
  end

  def create
    @vat_rate = BillingSetting.new(params[:billing_setting])
    BillingSetting.transaction do
      if @vat_rate.save
        redirect_to @vat_rate and return
      end
      render 'new'
    end
  end

  def edit
    @vat_rate = BillingSetting.find(params[:id])
  end

  def update
    @vat_rate = BillingSetting.find(params[:id])
    BillingSetting.transaction do
      if @vat_rate.update_attributes(params[:billing_setting])
        redirect_to @vat_rate and return
      end
      render 'edit'
    end
  end

  def show
    @vat_rate = BillingSetting.find(params[:id])
  end
end
