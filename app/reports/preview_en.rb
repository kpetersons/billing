class PreviewEn < Prawn::Document
  def width
    518
  end

  def to_pdf(invoice, current_user)
    font_families.update(
    "InvoiceFamily" => {
      :bold        => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Bold.ttf",
      :italic      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Italic.ttf",
      :bold_italic => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-BoldItalic.ttf",
      :normal      => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif.ttf" })

    font("InvoiceFamily") do
      move_down 152      
      header invoice, current_user
      body invoice, current_user
      footer invoice, current_user
    end
    render
  end

  private

  def header(invoice, current_user)

    head_info = make_table(
        [
          [
            customer_info_st(invoice),
            invoice_info_st(invoice)
          ]
        ],
        :width => width,
        :cell_style => {:borders =>[], :padding => 2},
                        :column_widths => [318, 200]
      )
    head_info.draw
    font_size(10) do
      move_down 10
      text "To the attention of: #{invoice.contact_person.name}" unless !invoice.contact_person.persisted?
      move_down 10
      refs_table = make_table(refs_st(invoice),
          :width => width,
          :cell_style=> {:borders => [], :padding => 2},
          :column_widths => [258, 260]
        )
      refs_table.draw
      move_down 10
      text invoice.subject
    end

  end

  def body(invoice, current_user)

    font_size(10) do
      move_down 5
      lines_table = make_table(lines(invoice),
          :width => width,
          :cell_style=> {:borders => [], :padding => 2},
          :column_widths => [250, 53, 53, 53, 53, 56]
        )
      lines_table.draw
      subtotals_table = make_table(subtotals_line(invoice),
          :width => width,
          :cell_style=> {:borders => [], :padding => 2},
          :column_widths => [356, 53, 53, 56]
        )
      subtotals_table.cells[0,0].style(:align => :right)
      subtotals_table.cells[0,1].style(:align => :right)
      subtotals_table.cells[0,2].style(:align => :right)
      subtotals_table.cells[0,3].style(:align => :right)
      subtotals_table.draw
      vat_table = make_table(vat_line(invoice),
          :width => width,
          :cell_style=> {:borders => [], :padding => 2},
          :column_widths => [356, 53, 53, 56]
        )
      vat_table.cells[0,0].style(:align => :right)
      vat_table.cells[0,3].style(:align => :right)              
      subtotals_table.draw
      font_size(12) do
        total_due_table = make_table(total_due_line(invoice),
          :width => width,
          :cell_style=> {:borders => [], :padding => 2},
          :column_widths => [450, 68]
        )
      total_due_table.cells[0,0].style(:align => :right,:font_style => :bold)
      total_due_table.cells[0,1].style(:align => :right,:font_style => :bold)
      total_due_table.draw
      end
    end

  end

  def footer (invoice, current_user)
    move_down 10
    font_size(10) do
      text "<b>VAT reverse charge procedure is applicable according to Art 44 of the EU Council directive 2006/112/EC and Art 41(a) of the Latvian Law on VAT</b>", :inline_format => true      
      text "Please remit within days #{invoice.payment_term}"
      text "Kindly refer to our Invoice number in your remittance"
    end
  end

  def customer_info_st invoice
    cust_info = Prawn::Table.new([
      ["#{invoice.customer_name}"],
      ["#{invoice.customer.inv_address.line_1}"],
      ["#{invoice.customer.inv_address.line_2}"],
      ["#{invoice.customer.inv_address.line_3}"],
      ["#{invoice.customer.inv_address.line_4}"],
      ["#{invoice.customer.inv_address.country.name}"]
    ], self, :column_widths => [318])
    cust_info.cells.style(:borders => [])
    return cust_info
  end

  def invoice_info_st invoice
    inv_info = Prawn::Table.new([["Invoice Nr. #{invoice.id}"]], self, :column_widths => [200])
    inv_info.cells.style(:borders => [:top, :right, :bottom, :left], :align => :center)
    return inv_info
  end

  def refs_st invoice
    your_ref = "#{invoice.your_ref}"
    your_date = "#{invoice.your_date}"
    our_ref = "#{invoice.our_ref}"
    our_date = "Riga,#{invoice.invoice_date.to_s(:show)}"
    po_billing = "#{invoice.po_billing}"
    rows = Array.new
    rows<<["Our date: #{our_date}", "Our ref: #{our_ref}"]
    rows<<["Your date: #{your_date}", "Your ref: #{your_ref}"]
    rows<<["Po billing no.: #{po_billing}"] unless po_billing.nil?
  end

  def lines invoice
    table = []
    table<<[
      "Action",
      "Unit",
      "Items",
      "Official fee #{invoice.currency.name}",
      "Agency fee #{invoice.currency.name}",
      "Line total #{invoice.currency.name}"
    ]
    counter = 1
    invoice.invoice_lines.each do |line|
      table<<[
        "#{counter}. #{line.provided_fee_description},#{line.provided_fee_details}",
        "#{line.units}",
        "#{line.items}",
        "#{line.official_fee_total}",        
        "#{line.attorney_fee_total}",
        "#{line.line_total}"
      ]
      counter = counter + 1
    end
    return table
  end
  
  def subtotals_line invoice
    return [[
      "Subtotal #{invoice.currency.name}", 
      "#{invoice.sum_official_fees}", 
      "#{invoice.sum_attorney_fees}",
      "#{invoice.sum_total_fees}" 
    ]]
  end
  
  def vat_line invoice
    return [[
      "VAT 22%", 
      "", 
      "",
      "#{invoice.sum_vat}" 
    ]]
  end  
  
  def total_due_line invoice
    return [[
      "Total due #{invoice.currency.name}", 
      "#{invoice.sum_total}"
    ]]  
  end
end