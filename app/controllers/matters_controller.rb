class MattersController < ApplicationController

  layout "matters"

  before_filter :show_column_filter, :only => [:index, :quick_search, :search]

  def index
    @order_by = params[:order_by]
    @direction = params[:direction]
    @matters = VMatters.where(:author_id => current_user.id).order("#{@order_by} #{@direction}").paginate(:page => params[:my_matters_page])
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
    @other_matters = VMatters.where("author_id != #{current_user.id}").where(:operating_party_id => current_user.operating_party.own_and_child_ids).paginate(:page => params[:param_name])
  end

  def quick_search
    @matters = VMatters.quick_search(params[:search], params[:param_name])
    @other_matters = []
    render 'index'
  end

  def search
    begin
      @detail_search = DetailSearch.new({:columns => @columns, :details => params[:detail_search][:details]})
      @order_by = params[:order_by]
      @direction = params[:direction]
      @matters = VMatters.where(@detail_search.query).where(:author_id => current_user.id).order("#{@order_by} #{@direction}").paginate(:page => params[:my_matters_page])
      @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
      @other_matters = VMatters.where("author_id != #{current_user.id}").where(:operating_party_id => current_user.operating_party.own_and_child_ids).paginate(:page => params[:param_name])
      render "index" and return
    rescue Exception
      flash.now[:error] = "Invalid search parameters. Check them again!"
    end
    @order_by = params[:order_by]
    @direction = params[:direction]
    @matters = VMatters.where(:author_id => current_user.id).order("#{@order_by} #{@direction}").paginate(:page => params[:my_matters_page])
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
    @other_matters = VMatters.where("author_id != #{current_user.id}").where(:operating_party_id => current_user.operating_party.own_and_child_ids).paginate(:page => params[:param_name])
    render"index"
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
    end
    if @matter_type.name.eql?("matters.legal")
      @document.matter.legal = Legal.new
    end
    if @matter_type.name.eql?("matters.design")
      @document.matter.design = Design.new
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
      if @document.save
        @matter = @document.matter
        @date_effective =DateTime.now

        @document.update_attribute(:version, 1)
        @matter.update_attribute(:version, 1)
        @document.update_attribute(:orig_id, @document.id)
        @matter.update_attribute(:orig_id, @matter.id)
        @document.update_attribute(:date_effective, @date_effective)
        @matter.update_attribute(:date_effective, @date_effective)

        @matter.generate_registration_number

        unless params[:document][:matter_attributes][:classes].nil?
          @matter.save_classes params
        end
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
      if @document.matter.should_update? params
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
            @matter.generate_registration_number
            @matter.save_classes params
          end
          redirect_to matter_path(@matter)
        else
          render 'edit'
        end
      else

        @date_effective =DateTime.now
        @document.matter.update_attribute(:date_effective_end, @date_effective)
        @document.update_attribute(:date_effective_end, @date_effective)

        if @document.version.nil?
          @document.update_attribute(:version, 1)
        end
        if @document.matter.version.nil?
          @document.matter.update_attribute(:version, 1)
        end

        params_copy = params.reject { |x| false }
        params_copy[:document].reject! { |x| x.eql?("id") }
        params_copy[:document][:matter_attributes].reject! { |x| x.eql?("id") }
        params_copy[:document][:matter_attributes][:trademark_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:trademark_attributes].nil?
        params_copy[:document][:matter_attributes][:trademark_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:trademark_attributes].nil?
        params_copy[:document][:matter_attributes][:patent_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:patent_attributes].nil?
        params_copy[:document][:matter_attributes][:design_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:design_attributes].nil?
        params_copy[:document][:matter_attributes][:legal_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:legal_attributes].nil?
        params_copy[:document][:matter_attributes][:custom_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:custom_attributes].nil?
        params_copy[:document][:matter_attributes][:domain_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:domain_attributes].nil?
        params_copy[:document][:matter_attributes][:search_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:search_attributes].nil?
        params_copy[:document][:matter_attributes][:patent_attributes].reject! { |x| x.eql?("id") } unless params_copy[:document][:matter_attributes][:patent_attributes].nil?

        @document_new = Document.new(params[:document])
        @document_new.orig_id = @document.orig_id || @document.id
        @document_new.version = @document.version + 1
        @document_new.date_effective = @date_effective

        @document_new.matter.orig_id = @document.matter.orig_id || @document.matter.id
        @document_new.matter.version = @document.matter.version + 1
        @document_new.matter.date_effective = @date_effective

        if @document_new.save
          @document_new.matter.generate_registration_number
          redirect_to matter_path(@document_new.matter) and return
        else
          @document = @document_new
          render 'edit'
        end
      end
    end
  end

  def show
    @matter = Matter.find(params[:id])
    @document = @matter.document
  end

  def choose
    @document = Document.new
    @matters = Matter.paginate(:page => params[:param_name])
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
    @matter = Matter.find(params[:id])
    if params[:from].nil?
      redirect to @matter
    end
    @linked = Matter.find(params[:from])
    LinkedMatter.delete_all(:matter_id => @matter.id, :linked_matter_id => @linked.id)
    LinkedMatter.delete_all(:matter_id => @linked.id, :linked_matter_id => @matter.id)
    redirect_to @matter
  end

  def find_ajax
    @result = []
    index = 0
    @matter = Matter.find(params[:id])
    @matters = Matter.where(['matters.id != ?', "#{@matter.id}"]).joins(:document).where(:matter_type_id => @matter.matter_type_id).all(:conditions => ['registration_number like ?', "%#{params[:query]}%"])
    @matters.each do |matter|
      @result<<{:id => matter.id, :label => matter.document.registration_number, :value => matter.document.registration_number}
      index += 1
    end
    render :json => @result
  end

  def add_image
    @matter = Matter.find(params[:id])
    @image = MatterImage.create(params[:matter_image])
    if @matter.matter_images<<@image
      flash.now[:success] = "matter.success.image.added"
      redirect_to @matter and return
    end
    flash.now[:error] = "matter.error.image.added"
    redirect_to @matter and return
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
