class InvoicePreviewsController < ApplicationController

  layout false
  def show
    @invoice = Invoice.find(params[:invoice_id])
    output = InvoicePreviewReport.new(:bottom_margin => 85, :left_margin => 51).to_pdf_lv(@invoice, current_user)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "invoice_#{@invoice.id}_preview.pdf",
                          :type => "application/pdf"
      end
      format.html do
        render 'show'
      end
    end
  end

end
