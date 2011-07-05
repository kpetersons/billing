class InvoicesController < ApplicationController

  layout "invoices"

  def index
    @invoices = Invoice.joins(:document).where(:documents => {:user_id => current_user.id}).paginate(:page => params[:param_name])
    @other_invoices = Invoice.joins(:document).where("user_id != #{current_user.id}").paginate(:page => params[:param_name])
  end

  def new
    @document = Document.new(:parent_id => params[:invoice_id])
    @document.invoice = Invoice.new
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
    @document.invoice.invoice_lines<<InvoiceLine.new if @document.invoice.invoice_lines.empty?
  end

  def add_line
    @invoice = Invoice.find(params[:id])        
    if !params[:invoice][:preset_id].empty?
      @preset = InvoiceLinePreset.find(params[:invoice][:preset_id])
      @invoice.invoice_lines<<InvoiceLine.new(
        :official_fee_type_id => @preset.official_fee_type_id,
        :attorney_fee_type_id => @preset.attorney_fee_type_id,
        :official_fee => @preset.official_fee,
        :attorney_fee => @preset.attorney_fee        
      )
    else
      @invoice.invoice_lines<<InvoiceLine.new            
    end
    redirect_to invoice_path(@invoice)
    flash[:success] = "Added a new line"
  end
  
  def remove_line
    @invoice = Invoice.find(params[:id])
    @invoice.invoice_lines.delete(InvoiceLine.find(params[:invoice_line_id]))
    redirect_to invoice_path(@invoice)
    flash[:success] = "Removed a line"    
  end

  def save_lines
    @invoice = Invoice.find(params[:id])
    @invoice.invoice_lines_attributes= (params[:invoice][:invoice_lines_attributes])    
    if @invoice.save      
      redirect_to invoice_path(@invoice)
    else
      flash[:error] = "Could not save lines"
      render 'show'
    end    
  end

  private
  
  def update_totals
    
  end

end
