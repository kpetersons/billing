class InvoicePreviewsController < ApplicationController

  layout false
  def show
    if params[:language].eql?("LV")
      show_lv params
    end
    if params[:language].eql?("EN")
      show_en params
    end    
  end
  
  def show_lv params
    @invoice = Invoice.find(params[:invoice_id])
    output = PreviewLv.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "lv_#{@invoice.id}_preview.pdf",
                          :type => "application/pdf"
      end
      format.html do
        render 'show'
      end
    end
  end

  def show_en params
    @invoice = Invoice.find(params[:invoice_id])
    output = PreviewEn.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "en_#{@invoice.id}_preview.pdf",
                          :type => "application/pdf"
      end
      format.html do
        render 'show'
      end
    end
  end

end
