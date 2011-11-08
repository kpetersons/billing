class InvoicePreviewsController < ApplicationController

  layout false

  def apreview
    @invoice = Invoice.find(params[:invoice_id])
    @lang = params[:language]
    @watermark = true
    @images = false
    render "invoice_previews/show"
  end

  def aprint
    @invoice = Invoice.find(params[:invoice_id])
    @lang = params[:language]
    @watermark = false
    @images = true
    render "invoice_previews/show"
  end

  def asave
    @invoice = Invoice.find(params[:invoice_id])
    @lang = params[:language]
    prev_lang = I18n.locale
    I18n.locale = @lang

    if @invoice.invoice_type ==0
      output = InvoicePdfLocal.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user, false, true)
      send_data output, :filename => "#{@lang}_#{@invoice.id}.pdf",
                :type => "application/pdf"
    else
      output = InvoicePdfForeign.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user, false, true)
      send_data output, :filename => "#{@lang}_#{@invoice.id}.pdf",
                :type => "application/pdf"
    end
    I18n.locale = prev_lang
  end

  def ainline
    @invoice = Invoice.find(params[:invoice_id])
    @lang = params[:language]
    @watermark = to_boolean(params[:watermark])
    @images = to_boolean(params[:images])

    prev_lang = I18n.locale
    I18n.locale = @lang

    if @invoice.invoice_type ==0
      output = InvoicePdfLocal.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user, @watermark, @images)
      send_data output, :filename => "#{@lang}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf",
                :disposition => 'inline'
    else
      output = InvoicePdfForeign.new(:bottom_margin => 85, :left_margin => 51).to_pdf(@invoice, current_user, @watermark, @images)
      send_data output, :filename => "#{@lang}_#{@invoice.id}_preview.pdf",
                :type => "application/pdf",
                :disposition => 'inline'
    end
    I18n.locale = prev_lang
  end

  private
  def to_boolean val
    return (val.eql?("true"))? true : false
  end

end
