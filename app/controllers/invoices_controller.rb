class InvoicesController < ApplicationController

  layout "invoices"

  def index
    @invoices = Invoice.joins(:document).where(:documents => {:user_id => current_user.id}).paginate(:page => params[:param_name])
    @other_invoices = Invoice.joins(:document).where("user_id != #{current_user.id}").paginate(:page => params[:param_name])
  end

  def new
    @document = Document.new(:parent_id => params[:invoice_id])
    @document.invoice = Invoice.new
    @document.invoice<<InvoiceLine.new
  end
  
  def create
    Document.transaction do
      @document = Document.new(params[:document].merge(:user_id => current_user.id))
      if @document.save
        @invoice = @document.invoice        
        redirect_to @invoice
      else
        render 'new'
      end
    end    
  end

  def edit
    @document = Invoice.find(params[:id]).document
  end

  def update
    @document = Document.find(params[:document][:id])
    Document.transaction do
      if @document.update_attributes(params[:document])
        @invoice = @document.invoice      
        redirect_to invoice_path(@invoice)
      else
        render 'edit'
      end
    end
  end

  def show
    @document = Invoice.find(params[:id]).document
  end

end
