class InvoicesController < ApplicationController

  layout "invoices"

  before_filter :show_column_filter, :only => :index

  def index
    @invoices = Invoice.joins(:document).where(:documents => {:user_id => current_user.id}).paginate(:per_page => 10, :page => params[:my_invoices_page])
    @other_invoices = Invoice.joins(:document).where("user_id != #{current_user.id}").paginate(:per_page => 10, :page => params[:other_invoices_page])
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
    @document.invoice.invoice_matters<<InvoiceMatter.new(
    :matter_id => (@matter.id unless @matter.nil?),
    :matter_task_id => (@matter_task.id unless @matter_task.nil?))
    end
    @document.invoice.customer = @matter.agent unless @matter.nil?
    @document.invoice.our_ref = "#{current_user.initials}/#{@matter.full_reg_nr_for_invoice}" unless @matter.nil?
  end

  def create
    Document.transaction do
      @document = Document.new(params[:document])
      if @document.save
      @invoice = @document.invoice
      redirect_to @invoice
      else
      render 'new'
      end
    end
  end

  def edit
    @document = Invoice.find(params[:id]).document
    @document.user_id = current_user.id
    @document.invoice.author_id = current_user.id
  end

  def update
    @document = Document.find(params[:document][:id])
    Document.transaction do
      if params[:document][:invoice_attributes][:address_id].nil?
        @document.invoice.address_id = nil
      end
      if @document.update_attributes(params[:document])
      @invoice = @document.invoice
      redirect_to invoice_path(@invoice)
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

  def remove_line
    @invoice = Invoice.find(params[:id])
    @invoice.invoice_lines.delete(InvoiceLine.find(params[:invoice_line_id]))
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
      if @invoice.update_attribute(:invoice_status_id, params[:invoice_status][:id])
      redirect_to invoice_path(@invoice) and return
      else
      redirect_to invoice_path(@invoice) and return
      end
    end
  end

  def reset
    UserFilterColumn.transaction do
      UserFilter.reset_filter current_user, 'invoices'
    end
    redirect_to invoices_path    
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

  private

  def do_save_lines
    @invoice.update_attributes(params[:invoice])
    if @invoice.save
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
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'invoices').first    
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    # 
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'invoices').first
    if filter.nil?
      filter = default_filter
    end
    @chosen_columns = UserFilterColumn.where(:user_filter_id => filter.id ).all
    if @chosen_columns.empty?
      @chosen_columns = DefaultFilterColumn.where(:default_filter_id => filter.id, :is_default => true).all
    end
  end
    
end
