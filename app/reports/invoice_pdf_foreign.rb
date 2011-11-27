class InvoicePdfForeign < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def curr dec
    number_to_currency(dec, {:unit => "", :delimiter => ''})
  end

  def currd dec
    number_to_currency(dec, {:unit => ""})
  end

  def width
    518
  end

  def to_pdf(invoice, current_user, watermark, images)
    if watermark
      for i in 0..page_count
        go_to_page i
        font_size(100)
        fill_color "939393"
        draw_text "Preview", :rotate => 45, :at => [100, 250], :font_style => :bold
         fill_color "000000"
      end
    end
    font_families.update(
    "InvoiceFamily" => {
      :bold        => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Bold.ttf",
      :italic      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Italic.ttf",
      :bold_italic => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-BoldItalic.ttf",
      :normal      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif.ttf" })

    font("InvoiceFamily") do

      move_down 87
      font_size(8) do
        head_table = Prawn::Table.new([
          [
            (customer_info_group invoice),
            (left_side_group invoice)
          ]
        ], self, :cell_style => {:borders => []})
        head_table.draw

        your_info_table = make_table([
          [
            (your_vat_group invoice),
            (attorney_in_charge_group invoice)
          ]
        ], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_bottom => 5, :padding_left => 0})
        your_info_table.cells[0,0].style :font_style => :bold
        your_info_table.cells[0,1].style :font_style => :bold_italic
        your_info_table.draw
        move_down 10
      end

      font_size(8) do
        (references_group invoice).draw
        (po_number_group invoice).draw
        (subject_group invoice).draw
        (invoice_line_caption_group invoice).draw
        (invoice_line_group invoice).draw
        group do
              if !invoice.discount.nil? && invoice.discount > 0
                discount = invoice_line_discount_group invoice
                discount.draw
              end
              #
              footer_group = invoice_line_footer_group invoice
              footer_group.draw
              move_down 20
              invoice_preparer_group invoice, current_user
        end
      end
    end
    render
  end

  private

  def customer_info_group invoice
    address_data = []
    address_data<<["#{invoice.customer_name}"]
    address_data<<["#{invoice.chk_address.line_1}"] unless invoice.chk_address.line_1.nil?
    address_data<<["#{invoice.chk_address.line_2}"] unless invoice.chk_address.line_2.nil?
    address_data<<["#{invoice.chk_address.line_3}"] unless invoice.chk_address.line_3.nil?
    address_data<<["#{invoice.chk_address.line_4}"] unless invoice.chk_address.line_4.nil?
    address_data<<["#{invoice.chk_address.line_5}"] unless invoice.chk_address.line_5.nil?

    cust_info = make_table(address_data, :width => 318, :cell_style => {:borders => [], :padding => 0})
    cust_info.cells.style(:borders => [])
    cust_info.cells[0,0].style :font_style => :bold
    return cust_info
  end

  def left_side_group invoice
    left_side = make_table([
                [(invoice_date_group invoice)],
                [(invoice_number_group invoice)]
              ], :width => 205, :cell_style => {:borders =>[], :padding => 2})
    left_side.cells[0,0].style :font_style => :bold
    left_side.cells[1,0].style :borders => [:top, :right, :bottom, :left], :font_style => :bold, :align => :center, :size => 10
    return left_side
  end

  def invoice_date_group invoice
    return I18n.t('foreign.print.invoice.head.date', :date => invoice.invoice_date.to_s(:show_invoice))
  end

  #
  def invoice_number_group invoice
    return I18n.t('foreign.print.invoice.head.invoice_no', :no => invoice.document.registration_number)
  end

  def your_vat_group invoice
    return I18n.t('foreign.print.invoice.refs.your_vat', :no=> invoice.customer.vat_registration_number) unless invoice.customer.vat_registration_number.nil?
    return ""
  end

  def attorney_in_charge_group invoice
    return I18n.t('foreign.print.invoice.refs.attorney_charge', :name=> invoice.contact_person.name) unless invoice.individual.nil?
  end

  def references_group invoice
    references = []
    references[0] = [
        I18n.t('foreign.print.invoice.refs.your_ref', :ref => invoice.your_ref),
        I18n.t('foreign.print.invoice.refs.our_ref', :initials => invoice.author.initials, :ref => invoice.our_ref)
    ]
    references_data = make_table(references, :width => 520, :cell_style => {:borders => [], :padding_left => 0}, :column_widths => [260, 260])
    return references_data
  end

  def po_number_group invoice
    po_data = [
        (invoice.po_billing.nil? || invoice.po_billing.gsub(" ", "").empty?)? "" : I18n.t('foreign.print.invoice.refs.po_number', :po => invoice.po_billing),
        (invoice.your_date.nil?)? "" : I18n.t('foreign.print.invoice.refs.your_date', :date => invoice.your_date.to_s(:show_invoice))]
    return make_table([po_data], :width => 520, :cell_style => {:borders => [], :padding_top => 0, :padding_left => 0}, :column_widths => [260, 260])
  end

  def subject_group invoice
    subject = make_table([[invoice.subject]], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_left => 0})
    subject.cells[0,0].style :font_style => :bold
    return subject
  end

  def invoice_line_caption_group invoice
    caption = make_table([[
        I18n.t('foreign.print.invoice.lines.caption')
                          ]], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_left => 0})
    return caption
  end

  def invoice_line_group invoice
    lines_table = make_table(
      lines(invoice),
      :width => width,
      :cell_style=> {:borders => [:top, :right, :bottom, :left], :padding => 5},
      :column_widths => [409, 53, 56]
    )
    lines_table.columns(1).style :align => :right
    lines_table.columns(2).style :align => :right
    return lines_table
  end

  def invoice_line_discount_group invoice
      discount = make_table([[
        "
        #{I18n.t('foreign.print.invoice.lines.discount', :discount => invoice.discount)}",
        "",
        (invoice.sum_discount == 0)? '-' : "-#{(curr invoice.sum_discount)}"
      ]],       :width => width,
      :cell_style => {:padding => 5},
      :column_widths => [409, 53, 56])
      discount.cells[0,2].style :align => :right
      return discount
  end

  def invoice_line_footer_group invoice
    line_footer_data = []
    line_footer_data<<[
      I18n.t('foreign.print.invoice.lines.subtotal', :curr => invoice.currency.name),
      (invoice.sum_official_fees == 0)? '-' : (curr invoice.sum_official_fees),
      (invoice.sum_attorney_fees - invoice.sum_discount == 0)? '-' : (curr invoice.sum_attorney_fees - invoice.sum_discount)
    ]
    line_footer_data<<[
      I18n.t('foreign.print.invoice.lines.vat'),
      "",
      "#{(invoice.sum_vat == 0)? '-' : (curr invoice.sum_vat)}"
    ] unless !invoice.apply_vat

    line_footer_table = make_table(
      line_footer_data,
      :width => 220,
      :cell_style => {:borders => [:top, :right, :left], :padding => 5},
      :column_widths => [111, 53, 56]
    )
    unless line_footer_table.cells[line_footer_table.row_length-2, 0].nil?
      line_footer_table.cells[line_footer_table.row_length-2, 0].style :align => :right, :borders => []
      line_footer_table.cells[line_footer_table.row_length-2, 1].style :align => :right, :borders => [:right]
      line_footer_table.cells[line_footer_table.row_length-2, 2].style :align => :right, :borders => []
    end
    unless line_footer_table.cells[line_footer_table.row_length-1, 0].nil?
      line_footer_table.cells[line_footer_table.row_length-1, 0].style :align => :right, :borders => [], :font_style => :bold
      line_footer_table.cells[line_footer_table.row_length-1, 1].style :align => :right, :borders => [:right], :font_style => :bold
      line_footer_table.cells[line_footer_table.row_length-1, 2].style :align => :right, :borders => [], :font_style => :bold
    end
    #    
    line_footer_table.columns(1).style :align => :right
    line_footer_table.columns(2).style :align => :right

    line_footer = make_table(
      [
        [invoice.ending_details, line_footer_table],
      ],
      :width => width, :column_widths => [298, 220], :cell_style => {:borders => []}
    )
    line_footer.cells[0,0].style :font_style => :italic

    totals = make_table(
      [
        [I18n.t('foreign.print.invoice.lines.total_due', :curr => invoice.currency.name),"#{(invoice.sum_total == 0)? '-' : (currd invoice.sum_total)}"]
      ],
      :width => width,
      :column_widths => [410, 108],
      :cell_style => {:borders => [], :size => 10}
    )

    totals.cells[0,0].style :align => :right, :font_style => :bold
    totals.cells[0,1].style :align => :right, :font_style => :bold

    footer = make_table(
        [
          [line_footer],
          [totals]
        ],
        :width => width, :column_widths => [width]
    )
    return footer
  end

  def invoice_preparer_group invoice, current_user
    group do
      text I18n.t('foreign.print.invoice.footer.var_reverse_disclaimer'), :inline_format => true
      move_down 20
      text I18n.t('foreign.print.invoice.footer.remit_disclaimer', :date => invoice.payment_term)
      text I18n.t('foreign.print.invoice.footer.ask_for_reference'), :inline_format => true
      move_down 30
      text current_user.individual.name
    end
  end

  def lines invoice
    table = []
    table<<[
      I18n.t('foreign.print.invoice.lines.description'),
      I18n.t('foreign.print.invoice.lines.official_fee', :curr => invoice.currency.name),
      I18n.t('foreign.print.invoice.lines.attorneys_fee', :curr => invoice.currency.name)
    ]
    counter = 1
    invoice.invoice_lines.each do |line|
      if line.items > 1 || (line.items < 1 && line.items > 0)
        line_data = make_table([
            ["#{counter}. #{line.offering_print}"],
            [line.line_details]
          ],
          :cell_style => {:borders => [], :padding => 0},
          :column_widths => [409])
      else
        line_data = make_table([
            ["#{counter}. #{line.offering}"],
            ["#{line.details}"]
          ],
          :cell_style => {:borders => [], :padding => 0},
          :column_widths => [409])
      end
      line_data.rows(1).style  :font_style => :italic
      table<<[line_data,
        "#{(line.total_official_fee == 0)? '-' : (curr line.total_official_fee)}",
        "#{(line.total_attorney_fee == 0)? '-' : (curr line.total_attorney_fee)}"
      ]
      counter = counter + 1
    end
    return table
  end

end