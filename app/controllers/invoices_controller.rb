class InvoicesController < ApplicationController

  layout "invoices"

  before_filter :show_column_filter, :only => [:index, :quick_search, :search]

  def index
    @order_by = params[:order_by]
    @direction = params[:direction]
    @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).order("#{@order_by} #{@direction}").paginate(:per_page => current_user.rows_per_page, :page => params[:my_invoices_page])
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
  end

  def quick_search
    @order_by = params[:order_by]
    @direction = params[:direction]
    @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).quick_search(params[:search], params[:my_invoices_page], current_user.rows_per_page)
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
    render 'index'
  end

  def search
    if params[:detail_search].nil? || params[:detail_search][:details].nil?
      redirect_to invoices_path and return
    end
    @detail_search = DetailSearch.new({:columns => @columns, :details => params[:detail_search][:details]})
    @order_by = params[:order_by]
    @direction = params[:direction]
    @precision = params[:precision]
    begin
      @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(@detail_search.query).order("#{@order_by} #{@direction}").paginate(:per_page => current_user.rows_per_page, :page => params[:my_invoices_page])
      @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
      @invoices_tot = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(@detail_search.query).order("#{@order_by} #{@direction}")

      logger.info "params[:detail_search][:totals][:calculate_totals]: #{params[:detail_search][:totals][:calculate_totals]}"
      if params[:detail_search][:totals][:calculate_totals] == 1.to_s
        logger.info "params[:detail_search][:totals][:calculate_totals]: #{params[:detail_search][:totals][:calculate_totals]} is one"
        @totals = {}
        logger.info 1
        @totals[:total_official_fee] = @invoices_tot.sum('total_official_fee')
        logger.info 2
        @totals[:total_attorneys_fee] = @invoices_tot.sum('total_attorney_fee')
        logger.info 3
        @totals[:total_official_and_attorneys_fee] = @invoices_tot.sum('total_official_fee') + @invoices_tot.sum('total_attorney_fee')
        logger.info 4
        @totals[:total_vat] = @invoices_tot.sum('total_vat')
        logger.info 5
        @totals[:grand_total] = @invoices_tot.sum('total_official_fee') + @invoices_tot.sum('total_attorney_fee') + @invoices_tot.sum('total_vat')
        logger.info 6
      end
      render "index" and return
    rescue => ex
      logger.debug ex
      flash.now[:error] = "Invalid search parameters. Check them again!"
      logger.error ex.message
    end
    @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(:author_id => current_user.id).order(params[:order], params[:direction]).paginate(:per_page => current_user.rows_per_page,:page => params[:my_invoices_page])
    render "index" and return
  end

  def new
    @document = Document.new(:user_id => current_user.id)
    @document.invoice = Invoice.new(
        :discount => 0,
        :invoice_status_id => InvoiceStatus.first.id,
        :author_id => current_user.id)
    @matter_task = MatterTask.find(params[:task_id]) unless params[:task_id].nil?
    @matter = Matter.find(params[:matter_id]) unless params[:matter_id].nil?
    if !@matter.nil? || !@matter_task.nil?
      @document.invoice.our_ref = @matter.document.registration_number
    end
    @document.invoice.customer = @matter.agent unless @matter.nil?
    @document.invoice.author_name = current_user.full_name
    #@document.invoice.our_ref = "#{current_user.initials}/#{@matter.full_reg_nr_for_invoice}" unless @matter.nil?
  end

  def create
    @document = Document.new(params[:document])
    Document.transaction do
      if @document.save
        @invoice = @document.invoice
        if do_save_refs @invoice, @invoice.our_ref_matters
          redirect_to @invoice and return
        else
          render 'new' and return
        end
      else
        render 'new' and return
      end
    end
    render 'new'
  end

  def edit
    @document = Invoice.find(params[:id]).document
    #@document.user_id = current_user.id
    #@document.invoice.author_id = current_user.id
  end

  def update
    @document = Document.find(params[:document][:id])
    Document.transaction do
      if params[:document][:invoice_attributes][:address_id].nil?
        @document.invoice.address_id = nil
      end
      if @document.update_attributes(params[:document])
        @invoice = @document.invoice
        if do_save_refs @invoice, @invoice.our_ref_matters
          redirect_to @invoice
        else
          render 'edit'
        end
      else
        render 'edit'
      end
    end
  end

  def show
    @document = Invoice.find(params[:id]).document
    @invoice_lines = Array.new
    #    @document.invoice.invoice_lines<<InvoiceLine.new if @document.invoice.invoice_lines.empty?
  end

  def copy
    Document.transaction do
      original = Invoice.find(params[:id]).document
      @document = Document.new(original.attributes)
      if @document.save
        @document.invoice = Invoice.new(original.invoice.attributes)
        if @document.invoice.save
          original.invoice.invoice_lines.each do |line|
            @document.invoice.invoice_lines<<InvoiceLine.new(line.attributes)
          end
          @invoice_lines = Array.new
          @document.copy = true
          render 'edit'
        else
          flash[:error] = "Could not copy invoice. Try again."
          redirect_to original.invoice
        end
      else
        flash[:error] = "Could not copy invoice. Try again."
        redirect_to original.invoice
      end
    end
  end

  def remove_line
    if !params[:invoice_line_id].nil?
      @invoice = Invoice.find(params[:id])
      @invoice.invoice_lines.delete(InvoiceLine.find(params[:invoice_line_id]))
    end
    redirect_to invoice_path(@invoice)
    flash[:success] = "Removed a line"
  end

  def process_lines
    @document = Invoice.find(params[:id]).document
    @invoice = @document.invoice
    if params[:save_lines]
      if do_save_lines
        redirect_to invoice_path(@invoice)
      else
        flash[:error] = "Could not save lines"
        render 'show' and return
      end
    end
    if params[:add_line]
      do_add_line
      flash.now[:success] = "Added a new line"
      render 'show'
    end
  end

  def flow
    @invoice = Invoice.find(params[:id])
    Invoice.transaction do
      if @invoice.update_attributes({:invoice_status_id => params[:invoice_status][:id]})
        redirect_to invoice_path(@invoice) and return
      end
    end
    @document = @invoice.document
    @invoice_lines = Array.new
    render 'show'
  end

  def reset
    UserFilterColumn.transaction do
      UserFilter.reset_filter current_user, 'invoices'
    end
    redirect_to invoices_path
  end

  def clear
    UserFilterColumn.transaction do
      UserFilter.clear_filter current_user, 'invoices'
    end
    redirect_to matters_path
  end

  def filter
    #params to array
    columns = params[:filter_selected_id].split(',')
    unless columns.empty?
      UserFilterColumn.transaction do
        # defaults
        default_filter = DefaultFilter.where(:table_name => 'invoices').first
        UserFilter.create_modified current_user, default_filter, columns
      end
    end
    redirect_to invoices_path
  end

  def save_results
    if params[:detail_search].nil? || params[:detail_search][:details].nil?
      @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).order("#{@order_by} #{@direction}")
      response.headers['Content-Type'] = 'text/csv'
      response.headers['Content-Disposition'] = "attachment; filename=results_#{DateTime.now}.xls"
      render :layout => false
      return
    end
    @detail_search = DetailSearch.new({:columns => @columns, :details => params[:detail_search][:details]})
    @order_by = params[:order_by]
    @direction = params[:direction]
    @precision = params[:precision]
    begin
      @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(@detail_search.query).order("#{@order_by} #{@direction}")
      @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
      @invoices_tot = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(@detail_search.query).order("#{@order_by} #{@direction}")

      logger.info "params[:detail_search][:totals][:calculate_totals]: #{params[:detail_search][:totals][:calculate_totals]}"
      if params[:detail_search][:totals][:calculate_totals] == 1.to_s
        logger.info "params[:detail_search][:totals][:calculate_totals]: #{params[:detail_search][:totals][:calculate_totals]} is one"
        @totals = {}
        logger.info 1
        @totals[:total_official_fee] = @invoices_tot.sum('total_official_fee')
        logger.info 2
        @totals[:total_attorneys_fee] = @invoices_tot.sum('total_attorney_fee')
        logger.info 3
        @totals[:total_official_and_attorneys_fee] = @invoices_tot.sum('total_official_fee') + @invoices_tot.sum('total_attorney_fee')
        logger.info 4
        @totals[:total_vat] = @invoices_tot.sum('total_vat')
        logger.info 5
        @totals[:grand_total] = @invoices_tot.sum('total_official_fee') + @invoices_tot.sum('total_attorney_fee') + @invoices_tot.sum('total_vat')
        logger.info 6
      end
      response.headers['Content-Type'] = 'text/csv'
      response.headers['Content-Disposition'] = "attachment; filename=results_#{DateTime.now}.xls"
      render :layout => false
      return
    rescue => ex
      logger.debug ex
      flash.now[:error] = "Invalid search parameters. Check them again!"
      logger.error ex.message
    end
    @invoices = VInvoices.where("matter_type_id in (?) or matter_type_id is null", current_user.operating_party.matter_types).where(:author_id => current_user.id).order(params[:order], params[:direction])
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=results_#{DateTime.now}.xls"
    render :layout => false
    return
  end

  private

  def do_save_refs invoice, matters
    logger.debug "invoice #{invoice}"
    logger.debug "matters #{matters}"
    if matters.empty?
      return
    end
    InvoiceMatter.delete(invoice.invoice_matters)
    matters.each do |matter|
      logger.debug "matter #{matter} invoice #{invoice}"
      invoice.invoice_matters.create :invoice_id => invoice.id, :matter_id => matter.id
    end
    #if matters.respond_to?(:each)
    #  invoice.matters= matters
    #else
    #  invoice.matters<<matters
    #end
  end

  def do_save_lines

    if @invoice.update_attributes(params[:invoice])
      return true
    else
      return false
    end
  end

  def do_add_line
    if !params[:invoice][:preset_id].empty?
      @preset = InvoiceLinePreset.find(params[:invoice][:preset_id])
      @invoice_line = @invoice.invoice_lines.build({
                                                       :official_fee_type_id => @preset.official_fee_type_id,
                                                       :attorney_fee_type_id => @preset.attorney_fee_type_id,
                                                       :official_fee => @preset.official_fee,
                                                       :attorney_fee => @preset.attorney_fee,
                                                       :offering => @preset.name,
                                                       :items => "1"}
      )
    else
      @invoice_line = @invoice.invoice_lines.build({:items => "1"})
    end
  end

  def show_column_filter
    @parameters = Marshal.load(Marshal.dump(params))
    @parameters.delete_if {|k,v| k.eql?"direction"}
    @parameters.delete_if {|k,v| k.eql?"order_by"}
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'invoices').first
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    @detail_search = DetailSearch.new :columns => @columns
    #
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'invoices').first
    if filter.nil?
      filter = default_filter
    end
    @chosen_columns = UserFilterColumn.where(:user_filter_id => filter.id).all
    if @chosen_columns.empty?
      @chosen_columns = DefaultFilterColumn.where(:default_filter_id => filter.id, :is_default => true).all
    end
  end

end
