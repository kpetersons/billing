class MattersController < ApplicationController

  layout "matters"

  before_filter :show_column_filter, :only => [:index, :quick_search, :search]

  def index
    @order_by = params[:order_by]
    @direction = params[:direction]
    @matters = VMatters.where(:matter_type_id => current_user.operating_party.matter_types).order("#{@order_by} #{@direction}").paginate(:per_page => current_user.rows_per_page, :page => params[:my_matters_page])
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
  end

  def quick_search
    @matters = VMatters.where(:matter_type_id => current_user.operating_party.matter_types).quick_search(params[:search], params[:param_name], current_user.rows_per_page)
    @other_matters = []
    render 'index'
  end

  def search
    if params[:detail_search].nil? || params[:detail_search][:details].nil?
      redirect_to matters_path and return
    end
    @detail_search = DetailSearch.new({:columns => @columns, :details => params[:detail_search][:details]})
    @order_by = params[:order_by]
    @direction = params[:direction]
    @precision = params[:precision]
    begin
      @matters = VMatters.where(:matter_type_id => current_user.operating_party.matter_types).where(@detail_search.query).order("#{@order_by} #{@direction}").paginate(:per_page => current_user.rows_per_page, :page => params[:my_matters_page])
      @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
      render "index" and return
    rescue => ex
      flash.now[:error] = "Invalid search parameters. Check them again!"
      logger.error ex.message
    end
    @matters = VMatters.where(:matter_type_id => current_user.operating_party.matter_types).order(params[:order]).paginate(:per_page => current_user.rows_per_page, :page => params[:my_matters_page])
    render "index" and return
  end

  def new
    flash.clear
    @document = Document.new(:parent_id => params[:matter_id])
    if params[:type].nil? || !MatterType.exists?(params[:type])
      flash[:error] = t("error.invalid.matter.type")
      redirect_to matters_path and return
    end
    @matter_type = MatterType.find(params[:type])
    flash.now[:success] = t("success.new.matter.type", {:matter_type => t(@matter_type.name)})
    @document.matter = Matter.new(
        :matter_type_id => @matter_type.id,
        :operating_party_id => current_user.operating_party_id,
        :matter_status_id => MatterStatus.first.id,
        :author_id => current_user.id)
    if @matter_type.name.eql?("matters.trademark")
      @document.matter.trademark = Trademark.new
    end
    if @matter_type.name.eql?("matters.patent")
      @document.matter.patent = Patent.new
      if params[:matter_id]
        parent_matter = Matter.where(:document_id => params[:matter_id]).first
        @document.matter.attributes = parent_matter.attributes.reject{|key, value| ['document_id', 'id', 'orig_id', 'matter_status_id', 'date_effective', 'author_id','created_at', 'updated_at'].include?(key)}
        @document.matter.patent.attributes = parent_matter.patent.attributes.reject{|key, value| ['matter_id', 'id', 'created_at', 'updated_at'].include?(key)}
      end
    end
    if @matter_type.name.eql?("matters.legal")
      @document.matter.legal = Legal.new
    end
    if @matter_type.name.eql?("matters.design")
      @document.matter.design = Design.new
      if params[:matter_id]
        parent_matter = Matter.where(:document_id => params[:matter_id]).first
        @document.matter.attributes = parent_matter.attributes.reject{|key, value| ['document_id', 'id', 'orig_id', 'matter_status_id', 'date_effective', 'author_id','created_at', 'updated_at'].include?(key)}
        @document.matter.design.attributes = parent_matter.design.attributes.reject{|key, value| ['matter_id', 'id', 'created_at', 'updated_at'].include?(key)}
      end
    end
    if @matter_type.name.eql?("matters.custom")
      @document.matter.custom = Custom.new
    end
    if @matter_type.name.eql?("matters.patent_search")
      @document.matter.patent_search = PatentSearch.new
    end
    if @matter_type.name.eql?("matters.trademark_search")
      @document.matter.search = Search.new
    end
    if @matter_type.name.eql?("matters.domain")
      @document.matter.domain = Domain.new
    end
    #    @document.matter.matter_images<<MatterImage.new
  end

  def create
    Document.transaction do
      @document = Document.new(params[:document].merge(:user_id => current_user.id))
      #@document.matter.unique_per_matter params[:document][:parent_id]
      if @document.save
        @matter = @document.matter
        @date_effective =DateTime.now

        @document.update_attribute(:version, 1)
        @matter.update_attribute(:version, 1)
        @document.update_attribute(:orig_id, @document.id)
        @matter.update_attribute(:orig_id, @matter.id)
        @document.update_attribute(:date_effective, @date_effective)
        @matter.update_attribute(:date_effective, @date_effective)

        @matter.generate_registration_number if @matter.document.parent_id.nil?

        unless params[:document][:matter_attributes][:classes].nil?
          @matter.save_classes params
        end
        @matter.create_customers_history
        redirect_to @matter
      else
        render 'new'
      end
    end
  end

  def edit
    @document = Matter.find(params[:id]).document
    #    @document.matter.matter_images<<MatterImage.new unless !@document.matter.matter_images.empty?
  end

  def update
    @document = Document.find(params[:document][:id])
    Document.transaction do
      if @document.update_attributes(params[:document])
        @matter = @document.matter
        @date_effective =DateTime.now

        @document.update_attribute(:version, @document.version + 1 || 1)
        @document.matter.update_attribute(:version, @document.matter.version + 1 || 1)
        @document.update_attribute(:orig_id, @document.id)
        @matter.update_attribute(:orig_id, @matter.id)
        @document.update_attribute(:date_effective, @date_effective)
        @matter.update_attribute(:date_effective, @date_effective)

        unless params[:document][:matter_attributes][:classes].nil?
          #@matter.generate_registration_number
          @matter.save_classes params
        end
        redirect_to matter_path(@matter)
      else
        render 'edit'
      end
    end
  end

  def show
    @matter = Matter.find(params[:id])
    @document = @matter.document
  end

  def choose
    @document = Document.new
    @matters = Matter.paginate(:per_page => current_user.rows_per_page, :page => params[:param_name])
  end

  def add
    Document.transaction do
      @document = Document.find_by_id(params[:document][:id])
      @child_matter = Matter.find(params[:matter_id])
      @document.child_documents<<@child_matter.document
      redirect_to @child_matter
    end
  end

  def remove
    Document.transaction do
      @matter_child = Matter.find(params[:matter_id])
      @matter_parent = Matter.find(params[:id])
      if @matter_child.document.update_attributes(:parent_id => nil)
        redirect_to @matter_child
      end
    end
  end

  def link
    @matter = Matter.find(params[:id])
    @document = @matter.document
    do_save_refs @matter, params[:linked_matter][:linked_matter_registration_number]
    redirect_to matter_path(@matter)
  end

  def unlink
    Matter.transaction do
      @matter = Matter.find(params[:id])
      if params[:from].nil?
        redirect to @matter
      end
      @linked = Matter.find(params[:from])
      LinkedMatter.delete(LinkedMatter.where(:linked_matter_id => @linked.id, :matter_id => @matter.id).first)
      LinkedMatter.delete(LinkedMatter.where(:linked_matter_id => @matter.id, :matter_id => @linked.id).first)
      redirect_to @matter
    end
  end

  def unlink_all
    Matter.transaction do
      @matter = Matter.find(params[:id])
      LinkedMatter.delete(LinkedMatter.where(:linked_matter_id => @matter.id).all)
      LinkedMatter.delete(LinkedMatter.where(:matter_id => @matter.id).all)
      redirect_to @matter
    end
  end

  def find_ajax
    @result = []
    index = 0
    @matter = Matter.find(params[:id])
    @matters = Matter.where(['matters.id != ?', "#{@matter.id}"]).joins(:document).where(:matter_type_id => @matter.matter_type_id).all(:conditions => ['registration_number ilike ?', "%#{params[:query]}%"])
    @matters.each do |matter|
      @result<<{:id => matter.id, :label => matter.document.registration_number, :value => matter.document.registration_number}
      index += 1
    end
    render :json => @result
  end

  def add_image
    @matter = Matter.find(params[:id])
    @document = @matter.document
    @image = MatterImage.create(params[:matter_image])
    if @matter.matter_images<<@image
      flash.now[:success] = "Image added."
      redirect_to @matter and return
    end
    flash.now[:error] = "Could not add image! Probably too large. Maximum image size = 2MB"
    render 'show'
  end

  def remove_image
    @matter = Matter.find(params[:id])
    @document = @matter.document
    @image = MatterImage.find(params[:image_id])
    if MatterImage.delete(@image)
      flash.now[:success] = "Image removed."
      redirect_to @matter and return
    end
    flash.now[:error] = "Could not remove image!"
    render 'show'
  end

  def flow
    @matter = Matter.find(params[:id])
    Matter.transaction do
      if @matter.update_attribute(:matter_status_id, params[:matter_status][:id])
        redirect_to matter_path(@matter) and return
      else
        redirect_to matter_path(@matter) and return
      end
    end
  end

  def reset
    UserFilterColumn.transaction do
      UserFilter.reset_filter current_user, 'matters'
    end
    redirect_to matters_path
  end

  def clear
    UserFilterColumn.transaction do
      UserFilter.clear_filter current_user, 'matters'
    end
    redirect_to matters_path
  end


  def filter
    #params to array
    columns = params[:filter_selected_id].split(',')
    unless columns.empty?
      UserFilterColumn.transaction do
        # defaults
        default_filter = DefaultFilter.where(:table_name => 'matters').first
        UserFilter.create_modified current_user, default_filter, columns
      end
    end
    redirect_to matters_path
  end

  private
  def do_save_refs source_matter, value
    result = []
    errors = []
    value.split(/;/).each do |item|
      items = item.split('-')
      if items.length < 2
        result << item
      else
        str_prefix = items[0].gsub(/[0-9]/, '')
        str_start = items[0].gsub(/[a-zA-Z]/, '')
        str_end = items[1].gsub(/[a-zA-Z]/, '')
        begin
          (Integer(str_start)..Integer(str_end)).each do |c_item|
            result<<"#{str_prefix}#{c_item}"
          end
        rescue ArgumentError
          errors<<"#{str_prefix}#{str_start}"
          errors<<"#{str_prefix}#{str_end}"
        end
      end
    end
    if result.length > 100
      return
    end
    Matter.transaction do
      result.each do |item|
        doc = Document.find_by_registration_number(item)
        unless doc.nil?
          matter = doc.matter
          if !matter.nil?
            LinkedMatter.new(:linked_matter_id => matter.id, :matter_id => source_matter.id).save
          end
        else
          source_matter.document.errors.add(:our_ref, "Could not find matter with registration number: #{item}")
          return false
        end
      end
    end
    refs = {:success => result, :error => errors}
    return refs
  end


  def show_column_filter
    @parameters = Marshal.load(Marshal.dump(params))
    @parameters.delete_if { |k, v| k.eql? "direction" }
    @parameters.delete_if { |k, v| k.eql? "order_by" }
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'matters').first
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    @detail_search = DetailSearch.new :columns => @columns
    #
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'matters').first
    if filter.nil?
      filter = default_filter
    end
    @chosen_columns = UserFilterColumn.where(:user_filter_id => filter.id).all
    if @chosen_columns.empty?
      @chosen_columns = DefaultFilterColumn.where(:default_filter_id => filter.id, :is_default => true).all
    end
  end

end
