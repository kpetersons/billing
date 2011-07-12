class CurrenciesController < ApplicationController

  layout "invoices"
  def index
    @currencies = Currency.paginate(:page => params[:param_name])
  end

  def show
    @currency = Currency.find_by_id(params[:id])
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
        redirect_to @currency and return
    else
      render 'show'
    end
  end

end
