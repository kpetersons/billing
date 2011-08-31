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

      move_down 87
      font_size(10) do
        head_table = Prawn::Table.new([
          [
            (customer_info_group invoice), 
            (left_side_group invoice)
          ]
        ], self, :cell_style => {:borders => []})
        head_table.draw
      end
      
      font_size(10) do
        your_info_table = make_table([
          [
            (your_vat_group invoice), 
            (attorney_in_charge_group invoice)
          ]
        ], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_bottom => 5})
        your_info_table.cells[0,0].style :font_style => :bold
        your_info_table.cells[0,1].style :font_style => :bold_italic
        your_info_table.draw
      end
      
      font_size(8) do
        (references_group invoice).draw
        (po_number_group invoice).draw
        (subject_group invoice).draw
        (invoice_line_caption_group invoice).draw
        (invoice_line_group invoice).draw
        group do
            font_size(8) do
              (invoice_line_footer_group invoice).draw
              move_down 20
              font_size(8) do
                invoice_preparer_group invoice, current_user
              end
            end
        end
      end
    end
    render
  end

  private

  def customer_info_group invoice
    cust_info = Prawn::Table.new([
      ["#{invoice.customer_name}"],
      ["#{invoice.customer.inv_address.line_1}"],
      ["#{invoice.customer.inv_address.line_2}"],
      ["#{invoice.customer.inv_address.line_3}"],
      ["#{invoice.customer.inv_address.line_4}"],
      ["#{invoice.customer.inv_address.line_5.name}"]
    ], self, :column_widths => [318])
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
    left_side.cells[1,0].style :borders => [:top, :right, :bottom, :left], :font_style => :bold, :align => :center
    return left_side
  end
  
  def invoice_date_group invoice
    return "Date: #{invoice.invoice_date.to_s(:show)}"
  end
  
  def invoice_number_group invoice
    return "Invoice No. #{invoice.id}"
  end
  
  def your_vat_group invoice
    return "Your VAT No. #{invoice.customer.vat_registration_number}"
  end
  
  def attorney_in_charge_group invoice
    return "Attorney in charge: #{invoice.contact_person.name}" unless invoice.individual.nil?
  end
  
  def references_group invoice
    references = []
    references[0] = ["Your Ref.: #{invoice.your_ref}", "Our Ref.: #{invoice.our_ref}"]
    references_data = make_table(references, :width => 520, :cell_style => {:borders => []})
    return references_data
  end
  
  def po_number_group invoice
    return make_table([["PO number: #{invoice.po_billing}"]], :width => 520, :cell_style => {:borders => [], :padding_top => 0})
  end
  
  def subject_group invoice
    subject = make_table([[invoice.subject]], :width => 520, :cell_style => {:borders => [], :padding_top => 5})
    subject.cells[0,0].style :font_style => :bold
    return subject
  end
  
  def invoice_line_caption_group invoice
    caption = make_table([["Our measures and costs specified below:"]], :width => 520, :cell_style => {:borders => [], :padding_top => 5})
    return caption    
  end
  
  def invoice_line_group invoice
    lines_table = make_table(
      lines(invoice),
      :width => width,
      :cell_style=> {:borders => [:top, :right, :bottom, :left], :padding => 2},
      :column_widths => [409, 53, 56]
    )
    lines_table.columns(1).style :align => :right
    lines_table.columns(2).style :align => :right    
    return lines_table
  end
  
  def invoice_line_footer_group invoice
    line_footer_table = make_table(
      [
        subtotals_line(invoice),
        vat_line(invoice),
        total_due_line(invoice)
      ],
      :width => width,
      :cell_style => {:borders => [:top, :right, :bottom, :left], :padding => 2},
      :column_widths => [409, 53, 56]
      
    )
    line_footer_table.cells[line_footer_table.row_length-3, 0].style :align => :right, :borders => [:left, :top]
    line_footer_table.cells[line_footer_table.row_length-2, 0].style :align => :right, :borders => [:left, :bottom]
    line_footer_table.cells[line_footer_table.row_length-1, 0].style :align => :right, :borders => [:left, :bottom], :font_style => :bold
    #
    line_footer_table.cells[line_footer_table.row_length-3, 1].style :align => :right, :borders => [:top]
    line_footer_table.cells[line_footer_table.row_length-2, 1].style :align => :right, :borders => [:bottom]
    line_footer_table.cells[line_footer_table.row_length-1, 1].style :align => :right, :borders => [:bottom], :font_style => :bold
    #
    line_footer_table.cells[line_footer_table.row_length-3, 2].style :align => :right, :borders => [:left, :top, :right]
    line_footer_table.cells[line_footer_table.row_length-2, 2].style :align => :right, :borders => [:left, :bottom, :right]
    line_footer_table.cells[line_footer_table.row_length-1, 2].style :align => :right, :borders => [:left, :bottom, :right], :font_style => :bold
    #    
    line_footer_table.columns(1).style :align => :right
    line_footer_table.columns(2).style :align => :right
    return line_footer_table
  end

  def invoice_preparer_group invoice, current_user
    group do
      font_size(10) do
        text "<b>VAT reverse charge procedure is applicable according to Art 44 of the EU Council directive 2006/112/EC and Art 41(a) of the Latvian Law on VAT</b>", :inline_format => true
        move_down 20
        text "Please remit within #{invoice.payment_term} days"
        text "Kindly refer to our Invoice number in your remittance"
        move_down 20
        text current_user.individual.name
      end
    end
  end

  def lines invoice
    table = []
    table<<[
      "Description",
      "Official fee #{invoice.currency.name}",
      "Attorney's fee #{invoice.currency.name}"
    ]
    counter = 1
    invoice.invoice_lines.each do |line|
      table<<[
        "#{counter}. #{line.provided_fee_description},#{line.provided_fee_details}",
        "#{line.official_fee_total}",
        "#{line.attorney_fee_total}"
      ]
      counter = counter + 1
    end
    return table
  end

  def subtotals_line invoice
    return [
        "Subtotal #{invoice.currency.name}",
        "#{invoice.sum_official_fees}",
        "#{invoice.sum_attorney_fees}"
    ]
  end

  def vat_line invoice
    return [
        "VAT 22%",
        "",
        "#{invoice.sum_vat}"
      ]
  end

  def total_due_line invoice
    return [
        "Total due #{invoice.currency.name}",
        "",
        "#{invoice.sum_total}"
      ]
  end
end