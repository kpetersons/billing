class InvoicePreviewsController < ApplicationController

  layout false

  def show
    @invoice = Invoice.find(params[:invoice_id])
  end

end
