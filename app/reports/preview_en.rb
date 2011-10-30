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
      end
      
      font_size(8) do
        (references_group invoice).draw
        (po_number_group invoice).draw 
        (subject_group invoice).draw
        (invoice_line_caption_group invoice).draw
        (invoice_line_group invoice).draw
        group do
              discount = invoice_line_discount_group invoice
              discount.draw unless discount.nil? 
              (invoice_line_footer_group invoice).draw
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
    left_side.cells[1,0].style :borders => [:top, :right, :bottom, :left], :font_style => :bold, :align => :center
    return left_side
  end
  
  def invoice_date_group invoice
    return "Date: #{invoice.invoice_date.to_s(:show_invoice)}"
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
    references_data = make_table(references, :width => 520, :cell_style => {:borders => [], :padding_left => 0})
    return references_data
  end
  
  def po_number_group invoice
    po_data = [(invoice.po_billing.nil? || invoice.po_billing.gsub(" ", "").empty?)? "" : "PO number: #{invoice.po_billing} ", (invoice.your_date.nil?)? "" : "Your date: #{invoice.your_date.to_s(:show_invoice)}"]
    return make_table([po_data], :width => 520, :cell_style => {:borders => [], :padding_top => 0, :padding_left => 0}, :column_widths => [260, 260])
  end
  
  def subject_group invoice
    subject = make_table([[invoice.subject]], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_left => 0})
    subject.cells[0,0].style :font_style => :bold
    return subject
  end
  
  def invoice_line_caption_group invoice
    caption = make_table([["Our measures and costs specified below:"]], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_left => 0})
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
    if !invoice.discount.nil? && invoice.discount > 0
      discount = make_table([[
        "
        Discount to our fees #{invoice.discount}%",
        "",
        "
        -#{invoice.sum_discount}"
      ]],       :width => width,
      :cell_style => {:padding => 5},
      :column_widths => [409, 53, 56])
      discount.cells[0,2].style :align => :right
      return discount 
    end
    return nil
  end
  
  def invoice_line_footer_group invoice
    line_footer_data = []
    line_footer_data<<[
      "Subtotal #{invoice.currency.name}",
      "#{invoice.sum_official_fees}",
      "#{invoice.sum_attorney_fees - invoice.sum_discount}"
    ]
    line_footer_data<<[
      "VAT 22%",
      "",
      "#{invoice.sum_vat}"
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
    
    totals = make_table(
      [
        ["Total due #{invoice.currency.name}","#{invoice.sum_total}"]
      ],
      :width => width, 
      :column_widths => [410, 108],
      :cell_style => {:borders => []}
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
      text "<b>VAT reverse charge procedure is applicable according to Art 44 of the EU Council directive 2006/112/EC and Art 41(a) of the Latvian Law on VAT</b>", :inline_format => true
      move_down 20
      text "Please remit within #{invoice.payment_term} days"
      text "Kindly refer to our Invoice number in your remittance"
      move_down 20
      text current_user.individual.name
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
      if line.items > 1 
        line_data = make_table([
            ["#{counter}. #{line.provided_fee_details}"],
            ["(#{line.items}#{line.units} x #{invoice.currency.name} #{line.attorney_fee}) #{line.provided_fee_description}"]
          ],
          :cell_style => {:borders => [], :padding => 0},        
          :column_widths => [409])
      else 
        line_data = make_table([
            ["#{counter}. #{line.provided_fee_details}"],
            ["#{line.provided_fee_description}"]
          ],
          :cell_style => {:borders => [], :padding => 0},        
          :column_widths => [409])
      end
      line_data.rows(1).style  :font_style => :italic
      table<<[line_data,
        "#{line.official_fee_total}",
        "#{line.attorney_fee_total}"
      ]      
      counter = counter + 1
    end
    return table
  end

end