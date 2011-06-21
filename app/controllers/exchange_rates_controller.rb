class ExchangeRatesController < ApplicationController
  
  layout "invoices"
  
  def index
    @exchange_rates = ExchangeRate.all
  end

  def edit
    @exchange_rate = ExchangeRate.find_by_id(params[:id])
  end
  
  def update
    @exchange_rate = ExchangeRate.find_by_id(params[:id])
    if @exchange_rate.update_attributes(:rate => params[:exchange_rate][:rate])
      redirect_to @exchange_rate.currency and return 
    end
    render 'edit' 
  end

end
