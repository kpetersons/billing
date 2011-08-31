class PreviewLv < Prawn::Document
    
  def to_pdf(invoice, current_user)
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
         txt = "REKINS Nr #{invoice.invoice_date.strftime("%y")}/#{invoice.number}"
         inv_number_cell = make_cell(:content =>txt)
         inv_number_cell.style(:font_style => :bold)
         inv_number_cell.width=width_of(txt)+50
         inv_number_cell.draw
      end
      move_down 30
      font_size(8) do  
        party_info_data = operating_party_table(invoice, current_user)
        party_info_data.concat(empty_two_col_table)
        party_info_data.concat(customer_party_table(invoice))
            
        party_info_table = make_table(party_info_data, :width => table_width, :cell_style => {:borders =>[], :padding => 2})
        party_info_table.draw    
        
        move_down 10
        ref_table = make_table(invoice_refs_table(invoice), :width => table_width, :cell_style => {:borders =>[], :padding => 3})
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
          text "<b>Rekina nr.</b>#{invoice.invoice_date.strftime("%y")}/#{invoice.number}", :inline_format => true
          text "<font size='9'>Lapa nr. #{page_count} no #{page_count}</font>", :inline_format => true
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
          text "<font size='9'>Lapa nr. #{1} no #{page_count}</font>", :inline_format => true
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
      "Riga,#{invoice.invoice_date.to_s(:show)}", ""
    ],     
    [
      "Musu ref.: #{invoice.our_ref}", "Jusu ref.: #{invoice.your_ref}"
    ],
    []
  end
  
  def operating_party_table invoice, current_user
    return [
      "Rekina nosutitajs", 
      I18n.t(current_user.operating_party.name),
      "Banka", 
      (current_user.operating_party.default_account.bank unless current_user.operating_party.default_account.nil?)
    ],
    [
      "Reg nr.", 
      current_user.operating_party.company.registration_number,
      "Bankas kods", 
      (current_user.operating_party.default_account.bank_code)
    ],
    [
      "PVN reg nr",
      "LV#{current_user.operating_party.company.registration_number}",  
      "Konta numurs",
      (current_user.operating_party.default_account.account_number)
    ],
    [
      "Juridiska adrese",
      current_user.operating_party.invoice_address      
    ]
  end  
  
  def customer_party_table invoice    
    return [
      "Rekina sanemejs", 
      invoice.customer.name,
      "Banka", 
      invoice.customer.default_account.bank
    ],
    [
      "Reg nr.", 
      invoice.customer.registration_number,
      "Bankas kods", 
      (invoice.customer.default_account.bank_code)
    ],
    [
      "PVN reg nr",
      "LV#{invoice.customer.registration_number}",  
      "Konta numurs",
      (invoice.customer.default_account.account_number)
    ]
  end
  
  def invoice_line_table_header
    return [   
      "Aprekinatas izmaksas",
      "Merv.",
      "Cena par 1 vien.",
      "Skaits",
      "Summa bez PVN"      
    ]
  end
  
  def invoice_line_table invoice
    table = []
    table<<invoice_line_table_header
    counter = 1
    invoice.invoice_lines.each do |line|           
      table<<[
        "#{counter}. #{line.provided_fee_description}", 
        line.units,
        line.provided_fee_amount,
        line.items, 
        line.provided_fee_without_vat
        ]
        counter = counter + 1
    end
    return table
  end
    
  def totals_invoice_line_table invoice
    return [
      "Ar PVN neapliekama summa",
      "",
      invoice.amount_without_vat
    ],
    [
      "Ar PVN 22% apliekama summa",
      "",
      invoice.amount_with_vat
    ],
    [
      "PVN 22",
      "",
      invoice.amount_vat
    ],
    [
      "Kopa summa apmaksai",
      "LVL",
      invoice.total_amount_with_vat      
    ]
  end
   
  def draw_invoice_footer (invoice, current_user)
    text "* Ar PVN neapliekamie pakalpojumi"
    move_down 10
    text "Ludzam veikt parskaitijumu 12 dienu laika."
    text "Maksajuma uzdevuma obligati noradiet musu rekina numuru!"
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