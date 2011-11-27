class InvoicePdfLocal < Prawn::Document

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
    table_width = 520
    move_down 87

    font_families.update(
                      "InvoiceFamily" => {
                            :bold        => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Bold.ttf",
                            :italic      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Italic.ttf",
                            :bold_italic => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-BoldItalic.ttf",
                            :normal      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif.ttf" })

    font("InvoiceFamily") do

      font_size(10) do
         txt = I18n.t('local.print.invoice.head.invoice_no', :no => "#{invoice.invoice_date.strftime("%y")}/#{invoice.number}")
         inv_number_cell = make_cell(:content =>txt)
         inv_number_cell.style(:font_style => :bold)
         inv_number_cell.width=width_of(txt)+50
         inv_number_cell.draw
      end
      move_down 30
      font_size(8) do
        party_info_data = operating_party_table(invoice, current_user)

        party_info_table = make_table(party_info_data, :width => table_width, :column_widths => [100, 200, 100, 120] , :cell_style => {:borders => [], :padding => 1})

        party_info_table.cells[0, 0].style :borders => [:left, :top]
        party_info_table.cells[0, 1].style :borders => [:top], :font_style => :bold
        party_info_table.cells[0, 2].style :borders => [:top]
        party_info_table.cells[0, 3].style :borders => [:top, :right], :font_style => :bold

        party_info_table.cells[1, 0].style :borders => [:left]
        party_info_table.cells[1, 1].style :font_style => :bold
        party_info_table.cells[1, 3].style :borders => [:right], :font_style => :bold
        party_info_table.cells[2, 0].style :borders => [:left]
        party_info_table.cells[2, 1].style :font_style => :bold
        party_info_table.cells[2, 3].style :borders => [:right], :font_style => :bold

        party_info_table.cells[3, 0].style :borders => [:left, :bottom]
        party_info_table.cells[3, 1].style :borders => [:bottom], :font_style => :bold
        party_info_table.cells[3, 2].style :borders => [:bottom]
        party_info_table.cells[3, 3].style :borders => [:bottom, :right], :font_style => :bold
        party_info_table.draw

        move_down 10

        party_info_data = customer_party_table(invoice)
        party_info_table = make_table(party_info_data, :width => table_width, :column_widths => [100, 200, 100, 120] , :cell_style => {:borders => [], :padding => 1})

        party_info_table.cells[0, 0].style :borders => [:left, :top]
        party_info_table.cells[0, 1].style :borders => [:top], :font_style => :bold
        party_info_table.cells[0, 2].style :borders => [:top]
        party_info_table.cells[0, 3].style :borders => [:top, :right], :font_style => :bold

        party_info_table.cells[1, 0].style :borders => [:left]
        party_info_table.cells[1, 1].style :font_style => :bold
        party_info_table.cells[1, 3].style :borders => [:right], :font_style => :bold
        party_info_table.cells[2, 0].style :borders => [:left]
        party_info_table.cells[2, 1].style :font_style => :bold
        party_info_table.cells[2, 3].style :borders => [:right], :font_style => :bold

        party_info_table.cells[3, 0].style :borders => [:left, :bottom]
        party_info_table.cells[3, 1].style :borders => [:bottom], :font_style => :bold
        party_info_table.cells[3, 2].style :borders => [:bottom]
        party_info_table.cells[3, 3].style :borders => [:bottom, :right], :font_style => :bold
        party_info_table.draw

        move_down 10
        ref_table = make_table(invoice_refs_table(invoice), :width => table_width, :cell_style => {:borders =>[], :padding_left => 0})
        ref_table.draw

        move_down 10
        text invoice.subject
        move_down 10
        line_table_data = invoice_line_table(invoice)
        line_table = make_table(line_table_data, :header => false, :width => table_width, :cell_style => {:borders => [], :padding => 3}, :column_widths => [310, 40, 65, 40, 65])

        line_table.rows(0).style(:borders => [:top, :bottom], :font_style => :bold)
        line_table.rows(line_table_data.length-1).style(:borders => [:bottom])
        line_table.columns(0).style(:borders => [:left])
        line_table.columns(line_table_data[0].length-1).style(:borders => [:right])
        line_table.cells[0,0].style(:borders => [:left, :top, :bottom])
        line_table.cells[0,line_table_data[0].length-1].style(:borders => [:right, :top, :bottom])

        line_table.cells[line_table_data.length-1,0].style(:borders => [:left, :bottom])
        line_table.cells[line_table_data.length-1,line_table_data[0].length-1].style(:borders => [:right, :bottom])

        line_table.draw

        if new_page?
          start_new_page
          move_down 57
          text I18n.t('local.print.invoice.head.invoice_no_small', :no => "#{invoice.invoice_date.strftime("%y")}/#{invoice.number}"), :inline_format => true
          text I18n.t('local.print.invoice.head.invoice_page_small', :from => page_count, :to => page_count), :inline_format => true
        end

        group(false) do
            line_table_totals_data  = totals_invoice_line_table invoice
            line_table_totals = make_table(line_table_totals_data, :width => table_width, :cell_style => {:borders => [], :padding => 3}, :column_widths => [415, 40, 65])
            line_table_totals.row(line_table_totals_data.length-1).style(:font_style => :bold)
            line_table_totals.columns(0).style(:align => :right)
            line_table_totals.draw
            move_down 10
            draw_invoice_footer invoice, current_user
        end
        if page_count > 1
          go_to_page 1
          move_down 152
          move_down 30
          text I18n.t('local.print.invoice.head.invoice_page_small', :from => page_count, :to => page_count), :inline_format => true
        end
      end
    end
    render
  end


  private

  def empty_two_col_table
    return ["", ""], []
  end

  def invoice_refs_table invoice
    return [
      I18n.t('local.print.invoice.head.created_place', :place => invoice.invoice_date.to_s(:show)),
      ""
    ],
    [
      I18n.t('local.print.invoice.refs.our_ref', :ref => invoice.our_ref),
      I18n.t('local.print.invoice.refs.your_ref', :ref => invoice.your_ref)
    ],
    []
  end

  def operating_party_table invoice, current_user
    return [
      I18n.t('local.print.invoice.refs.sender'),
      I18n.t(current_user.operating_party.name),
      I18n.t('local.print.invoice.refs.bank'),
      (current_user.operating_party.default_account.bank unless current_user.operating_party.default_account.nil?)
    ],
    [
      I18n.t('local.print.invoice.refs.sender_reg'),
      current_user.operating_party.company.registration_number,
      I18n.t('local.print.invoice.refs.sender_bank_code'),
      (current_user.operating_party.default_account.bank_code)
    ],
    [
      I18n.t('local.print.invoice.refs.sender_vat'),
      current_user.operating_party.company.registration_number,
      I18n.t('local.print.invoice.refs.sender_bank_acc'),
      (current_user.operating_party.default_account.account_number)
    ],
    [
      I18n.t('local.print.invoice.refs.sender_address'),
      current_user.operating_party.invoice_address.to_local_s,
      "",
      ""
    ]
  end

  def customer_party_table invoice
    return [
      I18n.t('local.print.invoice.refs.receiver'),
      invoice.customer.name,
      I18n.t('local.print.invoice.refs.bank'),
      invoice.customer.default_account.bank
    ],
    [
      I18n.t('local.print.invoice.refs.receiver_reg'),
      invoice.customer.registration_number,
      I18n.t('local.print.invoice.refs.receiver_bank_code'),
      (invoice.customer.default_account.bank_code)
    ],
    [
      I18n.t('local.print.invoice.refs.receiver_vat'),
      invoice.customer.registration_number,
      I18n.t('local.print.invoice.refs.receiver_bank_acc'),
      (invoice.customer.default_account.account_number)
    ],
    [
      I18n.t('local.print.invoice.refs.receiver_address'),
      invoice.customer.invoice_address.to_local_s,
      "",
      ""
    ]
  end

  def invoice_line_table_header
    return [
      I18n.t('local.print.invoice.lines.calc_costs'),
      I18n.t('local.print.invoice.lines.measurement'),
      I18n.t('local.print.invoice.lines.cost_one_unit'),
      I18n.t('local.print.invoice.lines.unit_count'),
      I18n.t('local.print.invoice.lines.cost_without_vat')
    ]
  end

  def invoice_line_table invoice
    table = []
    table<<invoice_line_table_header
    counter = 1
    invoice.invoice_lines.each do |line|
      line_data = make_table([
          ["#{counter}.#{(!line.official_fee_type_id.nil? && !line.official_fee_type.apply_vat?)? " * " : " "}#{line.offering}"],
          [line.details]
        ],
        :cell_style => {:borders => [], :padding => 0},
        :column_widths => [310])
      line_data.rows(1).style  :font_style => :italic
      table<<[
        line_data,
        line.units,
        (line.official_fee_type_id.nil?)? line.attorney_fee : line.official_fee,
        line.items,
        (line.official_fee_type_id.nil?)? line.total_attorney_fee : line.total_official_fee
        ]
        counter = counter + 1
    end
    return table
  end

  def totals_invoice_line_table invoice
    return [
      I18n.t('local.print.invoice.lines.sum_vat_exempt'),
      "",
      invoice.local_sum_exempt_vat
    ],
    [
      I18n.t('local.print.invoice.lines.sum_vat_taxable'),
      "",
      invoice.local_sum_taxable_vat
    ],
    [
      I18n.t('local.print.invoice.lines.vat_22'),
      "",
      invoice.local_sum_vat
    ],
    [
      I18n.t('local.print.invoice.lines.sum_to_pay'),
      I18n.t('local.print.invoice.lines.curr'),
      invoice.local_sum_total
    ]
  end

  def draw_invoice_footer (invoice, current_user)
    text I18n.t('local.print.invoice.footer.disclaimer')
    move_down 10
    text I18n.t('local.print.invoice.footer.payment_term', :term => invoice.payment_term)
    text I18n.t('local.print.invoice.footer.disclaimer1'), :inline_format => true
    move_down 20
    text current_user.full_name
  end

  def new_page?
    if (y/671).to_int < ((y+148)/671).to_int
      return true
    end
    return false
  end

end