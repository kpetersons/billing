class CurrenciesController < ApplicationController

  layout "invoices"
  def index
    @currencies = Currency.all
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
      if @currency.exchange_rates<<ExchangeRate.new(:from_date => Date.today, :rate => exchange_rate)
        redirect_to @currency
      else
        render 'show'
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
