class InvoicePreviewsController < ApplicationController

  layout false
  def show
    @invoice = Invoice.find(params[:invoice_id])
    if @invoice.invoice_type == 0
      show_local params, params[:language], params[:preview]
    else
      show_foreign params, params[:language], params[:preview]
    end    
  end
  
  def show_local params, lang, watermark

    output = PreviewLocal.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "#{lang}_#{@invoice.id}_preview.pdf",
                          :type => "application/pdf"
      end
      format.html do
        render 'show'
      end
    end
  end

  def show_foreign params, lang, watermark
    orig_locale = I18n.locale
    I18n.locale = lang
    output = PreviewForeign.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user, lang)
    respond_to do |format|
      format.pdf do
        send_data output, :filename => "#{lang}_#{@invoice.id}_preview.pdf",
                          :type => "application/pdf"
      end
      format.html do
        render 'show'
      end
    end
    I18n.locale=orig_locale
  end

end
