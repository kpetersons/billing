class AccountsController < ApplicationController

  layout :accounts_layout
  def index
    @accounts = Account.all
  end

  def new
    @customer = Customer.find(params[:customer_id]) unless params[:customer_id].nil?
    @operating_party = OperatingParty.find(params[:operating_party_id]) unless params[:operating_party_id].nil?
    @path_elements = [@customer, @operating_party].compact
    @account = Account.new(:company_id => @customer.party.company.id) unless @customer.nil?
    @account = Account.new(:company_id => @operating_party.company.id) unless @operating_party.nil?    
  end

  def create
    @account = Account.new(params[:account])
    Account.transaction do
      if @account.save
        redirect_to Customer.find(params[:customer_id]) and return unless params[:customer_id].nil?
        redirect_to OperatingParty.find(params[:operating_party_id]) unless params[:operating_party_id].nil? and return
      else
        render 'new'
      end
    end
  end

  def edit
    @account = Account.find(params[:id])
    @customer = Customer.find(params[:customer_id]) unless params[:customer_id].nil?
    @operating_party = OperatingParty.find(params[:operating_party_id]) unless params[:operating_party_id].nil?
    @path_elements = [@customer, @operating_party].compact    
  end

  def update
    @account = Account.find(params[:id])
    Account.transaction do
      if @account.update_attributes(params[:account])
        redirect_to Customer.find(params[:customer_id]) and return unless params[:customer_id].nil?
        redirect_to OperatingParty.find(params[:operating_party_id]) unless params[:operating_party_id].nil? and return
      else
        render 'edit'
      end
    end
  end

  def show
    @account = Account.find(params[:id])
  end

  private

  def accounts_layout
    unless params[:customer_id].nil?
      return 'customers'
    end
    return 'administration'
  end

end
