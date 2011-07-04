class InvoiceLinePresetsController < ApplicationController
  
  layout "invoices"

  def index
    @invoice_line_presets = InvoiceLinePreset.paginate(:page =>  params[:invoice_line_presets])
  end

  def new
    @invoice_line_preset = InvoiceLinePreset.new
  end

  def create
    @invoice_line_preset = InvoiceLinePreset.new(params[:invoice_line_preset])
    InvoiceLinePreset.transaction do
      if @invoice_line_preset.save
        redirect_to @invoice_line_preset and return
      end
      render 'new'
    end
  end

  def edit
    @invoice_line_preset = InvoiceLinePreset.find(params[:id])    
  end
  
  def update
    @invoice_line_preset = InvoiceLinePreset.find(params[:id])
    InvoiceLinePreset.transaction do
      if @invoice_line_preset.update_attributes(params[:invoice_line_preset])
        redirect_to @invoice_line_preset and return
      end
      render 'edit'
    end
  end  

  def show
    @invoice_line_preset = InvoiceLinePreset.find(params[:id])    
  end
end
