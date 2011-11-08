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

  def preview
    @invoice = Invoice.find(params[:invoice_id])
    if @invoice.invoice_type ==0
      output = InvoicePdfLocal.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
      send_data output, :filename => "#{params[:lang]}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf",
                :disposition => 'inline'
    else
      output = InvoicePdfForeign.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
      send_data output, :filename => "#{params[:lang]}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf",
                :disposition => 'inline'
    end
  end

  def show_local params, lang, watermark
    orig_locale = I18n.locale
    I18n.locale = lang
    if watermark
      @lang = lang
      render "invoice_previews/show"
    else
      output = InvoicePdfLocal.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
      send_data output, :filename => "#{lang}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf"
    end
    I18n.locale=orig_locale
  end

  def show_foreign params, lang, watermark
    orig_locale = I18n.locale
    I18n.locale = lang
    if watermark
      @lang = lang
      render "invoice_previews/show"
    else
      output = InvoicePdfForeign.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user)
      send_data output, :filename => "#{lang}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf"
    end
    I18n.locale=orig_locale
  end

end
