class InvoicePdfForeign < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def curr dec
    number_to_currency(dec, {:unit => "", :delimiter => ''})
  end

  def currd dec
    number_to_currency(dec, {:unit => ""})
  end

  def width
    #518
  end

  def to_pdf(invoice, current_user, watermark, images, top)

    if images
      bounding_box([112.220472, bounds.height - 51.023622], :width => 60.292) do # + 25.511811
        logo
      end
      bounding_box([0, bounds.height - 68.6062992], :width => 284.364) do # + 99.2125984
        party_profile
      end
    end

    fill_color "000000"

    font_families.update(
        "InvoiceFamily" => {
            :bold => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Bold.ttf",
            :italic => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-Italic.ttf",
            :bold_italic => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif-BoldItalic.ttf",
            :normal => "#{Rails.root}/app/reports/fonts/ttf/DejaVuSerif.ttf"})

    font("InvoiceFamily") do

      move_down 5.66929134

      if images
        move_down 10
      else
        move_down 87
      end


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
        your_info_table.cells[0, 0].style :font_style => :bold
        your_info_table.cells[0, 1].style :font_style => :bold_italic
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
          imgs = images
          invoice_preparer_group invoice, current_user, images
        end
      end
    end
    if images
      bounding_box([-15, 53], :width => 642.022) do
        footer
        fill do
          rectangle([0.346, 0.518], 559.305, 0.518)
        end
        bank_info
      end
    end
    if watermark
      for i in 0..page_count
        go_to_page i
        font_size(100)
        fill_color "939393"
        transparent(0.2) do
          draw_text "Preview", :rotate => 45, :at => [100, 250], :font_style => :bold
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
    cust_info.cells[0, 0].style :font_style => :bold
    return cust_info
  end

  def left_side_group invoice
    left_side = make_table([
                               [(invoice_date_group invoice)],
                               [(invoice_number_group (invoice))]
                           ], :width => 205, :cell_style => {:borders =>[], :padding_top => 6, :padding_bottom => 6})
    left_side.cells[0, 0].style :font_style => :bold
    left_side.cells[1, 0].style :borders => [:top, :right, :bottom, :left], :font_style => :bold, :align => :center, :size => 12, :height => 25
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
    return I18n.t('foreign.print.invoice.refs.attorney_charge', :name=> invoice.contact_person.name_wo_comma) unless invoice.individual.nil?
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
        (invoice.po_billing.nil? || invoice.po_billing.gsub(" ", "").empty?) ? "" : I18n.t('foreign.print.invoice.refs.po_number', :po => invoice.po_billing),
        (invoice.your_date.nil?) ? "" : I18n.t('foreign.print.invoice.refs.your_date', :date => invoice.your_date.to_s(:show_invoice))]
    return make_table([po_data], :width => 520, :cell_style => {:borders => [], :padding_top => 0, :padding_left => 0}, :column_widths => [260, 260])
  end

  def subject_group invoice
    subject = make_table([[invoice.subject]], :width => 520, :cell_style => {:borders => [], :padding_top => 5, :padding_left => 0})
    subject.cells[0, 0].style :font_style => :bold
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
                               (invoice.sum_discount == 0) ? '-' : "-#{(curr invoice.sum_discount)}"
                           ]], :width => width,
                          :cell_style => {:padding => 5},
                          :column_widths => [409, 53, 56])
    discount.cells[0, 2].style :align => :right
    return discount
  end

  def invoice_line_footer_group invoice
    line_footer_data = []
    line_footer_data<<[
        I18n.t('foreign.print.invoice.lines.subtotal', :curr => invoice.currency.name),
        (invoice.sum_official_fees == 0) ? '-' : (curr invoice.sum_official_fees),
        (invoice.sum_attorney_fees - invoice.sum_discount == 0) ? '-' : (curr invoice.sum_attorney_fees - invoice.sum_discount)
    ]
    line_footer_data<<[
        I18n.t('foreign.print.invoice.lines.vat'),
        "",
        "#{(invoice.sum_vat == 0) ? '-' : (curr invoice.sum_vat)}"
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
    line_footer.cells[0, 0].style :font_style => :italic

    totals = make_table(
        [
            [I18n.t('foreign.print.invoice.lines.total_due', :curr => invoice.currency.name), "#{(invoice.sum_total == 0) ? '-' : (currd invoice.sum_total)}"]
        ],
        :width => width,
        :column_widths => [410, 108],
        :cell_style => {:borders => [], :size => 10}
    )

    totals.cells[0, 0].style :align => :right, :font_style => :bold
    totals.cells[0, 1].style :align => :right, :font_style => :bold

    footer = make_table(
        [
            [line_footer],
            [totals]
        ],
        :width => width, :column_widths => [width]
    )
    return footer
  end

  def invoice_preparer_group invoice, current_user, images
    group do
      text I18n.t('foreign.print.invoice.footer.var_reverse_disclaimer'), :inline_format => true
      move_down 20
      text I18n.t('foreign.print.invoice.footer.remit_disclaimer', :date => invoice.payment_term)
      text I18n.t('foreign.print.invoice.footer.ask_for_reference'), :inline_format => true
      move_down 30
      imgs = images
      #todo ielikt i18n
      text (!images) ? invoice.author_name : "#{I18n.t('foreign.print.invoice_issued_by')} #{invoice.author_name }"
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
      line_data.rows(1).style :font_style => :italic
      table<<[line_data,
              "#{(line.total_official_fee == 0) ? '-' : (curr line.total_official_fee)}",
              "#{(line.total_attorney_fee == 0) ? '-' : (curr line.total_attorney_fee)}"
      ]
      counter = counter + 1
    end
    return table
  end

  def logo
    fill_color "990A2C"
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 4.9375, 48.5688)
    fill do
      move_to(0, 0)
      line_to(-0.961, 0.639)
      line_to(-3.215, -2.759)
      line_to(-2.256, -3.398)
    end
    restore_graphics_state
    save_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 9.4219, 34.647)
    fill do
      move_to(0, 0)
      line_to(-0.56, -2.328)
      line_to(-7.174, -0.737)
      line_to(-6.615, 1.592)
      line_to(-4.265, 1.026)
      curve_to([-5.748, 3.42], :bounds => [[-4.444, 1.76], [-4.942, 3.227]])
      curve_to([-6.697, 2.44], :bounds => [[-6.412, 3.581], [-6.572, 2.916]])
      line_to(-7.551, -1.107)
      line_to(-9.422, -0.082)
      line_to(-8.554, 3.532)
      curve_to([-5.403, 5.858], :bounds => [[-8.024, 5.729], [-6.623, 6.151]])
      curve_to([-1.97, 0.474], :bounds => [[-4.033, 5.529], [-2.582, 4.144]])
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 7.9199, 48.0674)
    fill do
      move_to(0, 0)
      line_to(-1.944, -3.122)
      line_to(-0.799, -3.838)
      line_to(0.972, -1.001)
      line_to(2.42, -2.564)
      line_to(0.947, -4.926)
      line_to(2.313, -5.779)
      line_to(4.392, -2.449)
      line_to(5.84, -4.012)
      line_to(2.793, -8.896)
      line_to(-4.957, -4.063)
      line_to(-2.041, 0.613)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 14.5313, 54.1709)
    fill do
      move_to(0, 0)
      line_to(-1.931, -1.667)
      line_to(2.696, -7.023)
      line_to(0.888, -8.588)
      line_to(-3.74, -3.231)
      line_to(-5.67, -4.899)
      line_to(-6.592, -2.976)
      line_to(-1.771, 1.191)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 21.8633, 57.5571)
    fill do
      move_to(0, 0)
      line_to(-3.375, -1.474)
      line_to(-2.832, -2.714)
      line_to(0.233, -1.375)
      line_to(0.545, -3.486)
      line_to(-2.008, -4.601)
      line_to(-1.363, -6.078)
      line_to(2.235, -4.505)
      line_to(2.549, -6.617)
      line_to(-2.731, -8.923)
      line_to(-6.394, -0.546)
      line_to(-1.338, 1.663)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 27.4922, 51.3672)
    fill do
      move_to(0, 0)
      line_to(-0.513, 6.779)
      line_to(-2.896, 6.6)
      line_to(-2.388, -0.18)
      move_to(1.433, 9.269)
      curve_to([4.375, 7.124], :bounds => [[3.598, 9.433], [4.297, 8.161]])
      curve_to([2.642, 4.101], :bounds => [[4.477, 5.797], [3.637, 4.849]])
      curve_to([5.574, 0.419], :bounds => [[3.447, 2.76], [4.459, 1.535]])
      line_to(3.686, -1.114)
      curve_to([-0.246, 4.299], :bounds => [[2.084, 0.448], [0.812, 2.326]])
      curve_to([1.696, 6.654], :bounds => [[0.342, 4.825], [1.762, 5.795]])
      curve_to([0.506, 7.136], :bounds => [[1.649, 7.267], [0.931, 7.168]])
      line_to(-3.363, 6.844)
      line_to(-2.961, 8.938)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 39.4941, 57.1348)
    fill do
      move_to(0, 0)
      line_to(-1.957, 0.475)
      curve_to([-2.887, 0.392], :bounds => [[-2.186, 0.532], [-2.803, 0.739]])
      curve_to([-2.654, -0.32], :bounds => [[-2.945, 0.141], [-2.775, -0.106]])
      line_to(-1.475, -2.507)
      curve_to([-0.893, -4.894], :bounds => [[-1.066, -3.251], [-0.678, -4.013]])
      curve_to([-3.783, -6.364], :bounds => [[-1.086, -5.687], [-1.838, -6.839]])
      line_to(-6.486, -5.706)
      line_to(-6.545, -3.575)
      line_to(-4.438, -4.088)
      curve_to([-3.508, -4.003], :bounds => [[-4.209, -4.144], [-3.592, -4.351]])
      curve_to([-3.734, -3.292], :bounds => [[-3.445, -3.753], [-3.617, -3.505]])
      line_to(-4.879, -1.126)
      curve_to([-5.445, 1.269], :bounds => [[-5.27, -0.374], [-5.662, 0.387]])
      curve_to([-2.557, 2.74], :bounds => [[-5.254, 2.062], [-4.502, 3.213]])
      line_to(-0.057, 2.131)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 45.8906, 52.0239)
    fill do
      move_to(0, 0)
      curve_to([-0.539, 2.254], :bounds => [[0.656, 1.028], [0.451, 1.623]])
      curve_to([-2.811, 1.793], :bounds => [[-1.527, 2.886], [-2.152, 2.821]])
      curve_to([-3.357, -2.167], :bounds => [[-3.701, 0.397], [-4.123, -1.681]])
      curve_to([0, 0], :bounds => [[-2.596, -2.656], [-0.891, -1.396]])
      move_to(-4.854, 3.229)
      curve_to([0.611, 4.055], :bounds => [[-3.787, 4.898], [-2.096, 5.781]])
      curve_to([2.162, -1.248], :bounds => [[3.316, 2.328], [3.23, 0.422]])
      curve_to([-4.52, -3.988], :bounds => [[0.857, -3.293], [-2.145, -5.503]])
      curve_to([-4.854, 3.229], :bounds => [[-6.896, -2.473], [-6.158, 1.182]])
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 49.4492, 39.7329)
    fill do
      move_to(0, 0)
      line_to(-1.398, 1.941)
      line_to(0.787, 3.518)
      line_to(1.805, 7.367)
      line_to(1.791, 7.386)
      line_to(-2.893, 4.01)
      line_to(-4.291, 5.952)
      line_to(3.121, 11.297)
      line_to(4.457, 9.447)
      line_to(3.49, 5.467)
      line_to(6.016, 7.288)
      line_to(7.414, 5.345)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 51.4785, 32.271)
    fill do
      move_to(0, 0)
      line_to(-0.598, 2.319)
      line_to(2.209, 3.042)
      line_to(1.559, 5.577)
      curve_to([-1.02, 3.967], :bounds => [[0.564, 5.31], [-0.307, 4.695]])
      line_to(-2.752, 5.533)
      curve_to([1.293, 8.041], :bounds => [[-1.684, 6.72], [-0.268, 7.639]])
      curve_to([5.951, 7.541], :bounds => [[2.832, 8.437], [4.564, 8.361]])
      curve_to([8.521, 3.567], :bounds => [[7.518, 6.625], [8.092, 5.237]])
      line_to(8.814, 2.43)
      line_to(6.959, 1.375)
      line_to(6.49, 3.196)
      curve_to([3.609, 5.862], :bounds => [[5.855, 5.677], [4.443, 5.766]])
      line_to(4.203, 3.555)
      line_to(5.992, 4.015)
      line_to(6.588, 1.696)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 4.3281, 14.5703)
    fill do
      move_to(0, 0)
      line_to(-1.285, 2.021)
      line_to(4.457, 5.668)
      line_to(5.74, 3.647)
      line_to(3.701, 2.352)
      curve_to([6.453, 1.754], :bounds => [[4.354, 1.972], [5.756, 1.311]])
      curve_to([6.41, 3.119], :bounds => [[7.028, 2.121], [6.664, 2.697]])
      line_to(4.453, 6.197)
      line_to(6.49, 6.83)
      line_to(8.481, 3.693)
      curve_to([7.967, -0.188], :bounds => [[9.694, 1.787], [9.022, 0.484]])
      curve_to([1.709, 1.084], :bounds => [[6.776, -0.944], [4.772, -1.023]])
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 14.1445, 4.3633)
    fill do
      move_to(0, 0)
      line_to(-1.871, 1.492)
      line_to(-0.065, 3.758)
      line_to(-2.112, 5.389)
      curve_to([-3.201, 2.551], :bounds => [[-2.746, 4.576], [-3.067, 3.561]])
      line_to(-5.524, 2.758)
      curve_to([-3.808, 7.192], :bounds => [[-5.388, 4.349], [-4.812, 5.935]])
      curve_to([0.211, 9.599], :bounds => [[-2.815, 8.437], [-1.394, 9.418]])
      curve_to([4.651, 7.977], :bounds => [[2.01, 9.811], [3.306, 9.049]])
      line_to(5.572, 7.244)
      line_to(4.728, 5.287)
      line_to(3.256, 6.457)
      curve_to([-0.647, 6.852], :bounds => [[1.254, 8.054], [0.076, 7.274]])
      line_to(1.215, 5.367)
      line_to(2.365, 6.81)
      line_to(4.235, 5.318)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 26.9199, 6.998)
    fill do
      move_to(0, 0)
      line_to(-2.438, 0.748)
      line_to(-4.521, -6.022)
      line_to(-6.81, -5.318)
      line_to(-4.729, 1.451)
      line_to(-7.166, 2.201)
      line_to(-6.026, 4.004)
      line_to(0.067, 2.131)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 33.8711, 7.1494)
    fill do
      move_to(0, 0)
      line_to(-3.679, -0.074)
      line_to(-3.649, -1.427)
      line_to(-0.309, -1.358)
      line_to(-0.826, -3.427)
      line_to(-3.608, -3.483)
      line_to(-3.576, -5.093)
      line_to(0.35, -5.013)
      line_to(-0.17, -7.082)
      line_to(-5.927, -7.199)
      line_to(-6.113, 1.935)
      line_to(-0.602, 2.046)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 44.6738, 3.501)
    fill do
      move_to(0, 0)
      line_to(-2.223, -0.89)
      line_to(-3.223, 1.614)
      line_to(-6.711, 3.53)
      line_to(-6.73, 3.522)
      line_to(-4.59, -1.836)
      line_to(-6.811, -2.724)
      line_to(-10.203, 5.758)
      line_to(-8.086, 6.606)
      line_to(-4.461, 4.708)
      line_to(-5.613, 7.595)
      line_to(-3.393, 8.483)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 48.2793, 15.4873)
    fill do
      move_to(0, 0)
      line_to(-1.895, -1.705)
      line_to(2.84, -6.974)
      line_to(1.061, -8.573)
      line_to(-3.676, -3.306)
      line_to(-5.574, -5.013)
      line_to(-6.533, -3.106)
      line_to(-1.791, 1.157)
    end
    restore_graphics_state
    save_graphics_state
    transformation_matrix(1, 0, 0, 1, 51.4512, 20.8291)
    fill do
      move_to(0, 0)
      line_to(-1.031, -1.728)
      curve_to([-1.225, -2.64], :bounds => [[-1.15, -1.929], [-1.533, -2.457]])
      curve_to([-0.479, -2.63], :bounds => [[-1.004, -2.772], [-0.717, -2.683]])
      line_to(1.961, -2.146)
      curve_to([4.412, -2.295], :bounds => [[2.791, -1.979], [3.633, -1.83]])
      curve_to([4.965, -5.489], :bounds => [[5.111, -2.712], [5.99, -3.771]])
      line_to(3.537, -7.88)
      line_to(1.484, -7.306)
      line_to(2.598, -5.442)
      curve_to([2.791, -4.53], :bounds => [[2.717, -5.242], [3.1, -4.712]])
      curve_to([2.043, -4.539], :bounds => [[2.568, -4.397], [2.281, -4.487]])
      line_to(-0.361, -4.991)
      curve_to([-2.816, -4.828], :bounds => [[-1.197, -5.144], [-2.041, -5.292]])
      curve_to([-3.371, -1.632], :bounds => [[-3.52, -4.41], [-4.396, -3.353]])
      line_to(-2.053, 0.575)
    end
    restore_graphics_state
    restore_graphics_state
  end

  def party_profile
    font_families.update(
        "party_profile" => {
            :normal => "#{Rails.root}/app/reports/fonts/Adobe Caslon Pro.ttf"})

    font("party_profile") do
      font_size(7.36) do
        fill_color "7E8083"
        text I18n.t("foreign.print.party_profile.line_1"), :align => :center
        text I18n.t("foreign.print.party_profile.line_2"), :align => :center
        move_down 10
        text I18n.t("foreign.print.party_profile.line_3"), :align => :center
      end
    end
  end

  def footer
    font_families.update(
        "footer" => {
            :normal => "#{Rails.root}/app/reports/fonts/Times_New_Roman.ttf",
            :bold => "#{Rails.root}/app/reports/fonts/Times_New_Roman_bold.ttf"})

    font("InvoiceFamily") do
      fill_color "7E8083"
      text I18n.t("foreign.print.footer.company"), :inline_format => true
      text I18n.t("foreign.print.footer.address"), :inline_format => true
    end
  end

  def bank_info
    font_families.update(
        "footer" => {
            :normal => "#{Rails.root}/app/reports/fonts/Times_New_Roman.ttf",
            :bold => "#{Rails.root}/app/reports/fonts/Times_New_Roman_bold.ttf"})

    font("footer") do
      move_down 8
      draw_text "BANKS", :at => [0, cursor], :size => 8.13, :style => :bold
      move_down 10
      draw_text "Beneficiary:", :at => [0, cursor], :size => 8.15

      draw_text "IBAN LV91 UNLA 0050 0006 26706", :at => [80, cursor], :size => 8.13

      fill do
        rectangle([210, cursor - 2], 20, cursor - 10)
      end
      fill_color "ffffff"
      draw_text "EUR", :at => [211.5, cursor], :size => 8.13
      fill_color "7E8083"

      draw_text "IBAN LV 52 HABA 0019 4090 46866", :at => [240, cursor], :size => 8.13
      fill do
        rectangle([372, cursor - 2], 20, cursor - 10)
      end
      fill_color "ffffff"
      draw_text "EUR", :at => [373, cursor], :size => 8.13
      fill_color "7E8083"


      draw_text "IBAN LV 52 HABA 0019 4090 46866", :at => [400, cursor], :size => 8.13
      fill do
        rectangle([532, cursor - 2], 20, cursor - 10)
      end
      fill_color "ffffff"
      draw_text "USD", :at => [533, cursor], :size => 8.13
      fill_color "7E8083"

      move_down 10
      draw_text "Beneficiary bank:", :at => [0, cursor], :size => 8.15

      draw_text "SEB Banka", :at => [80, cursor], :size => 8.13
      draw_text "SWIFT code: UNLALV2X", :at => [80, cursor-10], :size => 8.13

      draw_text "SWEDBANK", :at => [240, cursor], :size => 8.13
      draw_text "SWIFT code: HABALV22", :at => [240, cursor-10], :size => 8.13

      draw_text "SWEDBANK", :at => [400.242, cursor], :size => 8.13
      draw_text "SWIFT code: HABALV22", :at => [400, cursor-10], :size => 8.13

      move_down 25
      draw_text "Intermediary bank:", :at => [0, cursor], :size => 8.15

      draw_text "Deutsche Bank AG, Frankfurt am Main", :at => [80, cursor], :size => 8.13
      draw_text "SWIFT code: DEUTDEFF", :at => [80, cursor-10], :size => 8.13

      draw_text "Deutsche Bank AG, Frankfurt am Main", :at => [240, cursor], :size => 8.13
      draw_text "SWIFT code: DEUT DE FF", :at => [240, cursor-10], :size => 8.13

      draw_text "Deutsche Bank Trust Company Americas, NY", :at => [400, cursor], :size => 8.13
      draw_text "ABA/FW: 021001033", :at => [400, cursor-10], :size => 8.13
      draw_text "SWIFT Code: BKTR US 33", :at => [400, cursor-20], :size => 8.13
    end
  end

end