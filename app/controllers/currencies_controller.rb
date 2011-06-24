class CurrenciesController < ApplicationController

  layout "invoices"
  def index
    @currencies = Currency.paginate(:page => params[:param_name])
  end

  def show
    @currency = Currency.find_by_id(params[:id])
    @exchange_rates = ExchangeRate.find_by_currency_id(params[:id])
  end

  def new
    @currency = Currency.new
  end

  def create
    Currency.transaction do
      @currency = Currency.new(:params[:currency])
      if @currency.save
        redirect_to @currency
      else
        render 'new'
      end
    end
  end

  def edit
    @currency = Currency.find_by_id(params[:id])
  end

  def update
    @currency = Currency.find_by_id(params[:id])
    if @currency.update_attributes(params[:currency])
      exchange_rate = params[:currency][:rate]
      prev_rate = @currency.exchange_rates.first      
      if exchange_rate.empty? || prev_rate.rate.to_s == exchange_rate.to_s
        flash.now[:error] = "Currency is either empty or the same as previously!"                
        render 'show' and return
      end
      if @currency.exchange_rates<<ExchangeRate.new(:from_date => Date.today, :rate => exchange_rate)
        prev_rate.update_attributes(:through_date => Date.today)
        redirect_to @currency and return
      end
    else
      render 'show'
    end
  end

  def add_rate
    @currency = Currency.find_by_id(params[:id])
    @exchange_rate = ExchangeRate.new(params[:exchange_rate])
    if @exchange_rate.save
      redirect_to @currency
    else
      render 'edit'
    end
  end

end
