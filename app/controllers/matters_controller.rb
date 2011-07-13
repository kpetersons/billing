class MattersController < ApplicationController

  layout "matters"
  
  def index    
    @matters = Matter.joins(:document).where(:documents => {:user_id => current_user.id}).paginate(:page => params[:param_name])
    @other_matters = Matter.joins(:document).where("user_id != #{current_user.id}").paginate(:page => params[:param_name])
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
      :author_id => current_user.id) 
    if @matter_type.name.eql?("matter.trademark")
      @document.matter.trademark = Trademark.new
    end  
    if @matter_type.name.eql?("matter.patent")
      @document.matter.patent = Patent.new
    end
    if @matter_type.name.eql?("matter.legal")
      @document.matter.legal = Legal.new
    end        
    if @matter_type.name.eql?("matter.design")
      @document.matter.design = Design.new
    end    
    if @matter_type.name.eql?("matter.custom")
      @document.matter.custom = Custom.new
    end
    @document.matter.matter_images<<MatterImage.new    
  end

  def create    
    Document.transaction do
      @document = Document.new(params[:document].merge(:user_id => current_user.id))
      if @document.save
        @matter = @document.matter        
        redirect_to matter_path(@matter)
      else
        render 'new'
      end
    end
  end

  def edit
    @document = Matter.find(params[:id]).document
    @document.matter.matter_images<<MatterImage.new unless !@document.matter.matter_images.empty?
  end

  def update
    @document = Document.find(params[:document][:id])
    Document.transaction do
      if @document.update_attributes(params[:document])
        @matter = @document.matter
        matter_clazzs = params[:document][:matter_attributes][:classes]      
        matter_clazzs.split(',').each do |name|
          clazz = Clazz.find_by_code(name)
          unless clazz.nil?
            if MatterClazz.where(:matter_id => @matter.id, :clazz_id => clazz.id).first.nil?
              @matter.matter_clazzs<<MatterClazz.new(:clazz_id => clazz.id, :matter_id => @matter.id)
            end
          end
        end        
        redirect_to matter_path(@matter)
      else
        render 'edit'
      end
    end
  end

  def show
    @matter = Matter.find(params[:id])
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
#    puts split_to_arry :value => params[:linked_matter][:linked_matter_registration_number]
    Matter.transaction do
      @matter = Matter.find(params[:id])
      link_to = params[:linked_matter][:linked_matter_id]
      if @matter.linked_matters.exists?(:linked_matter_id => link_to) || @matter.linked_matters.exists?(:matter_id => link_to)
        flash[:warning] = t("error.matter.link_exists")
        redirect_to @matter and return
      end
      if @matter.linked_matters<<LinkedMatter.new(params[:linked_matter])
        flash[:success] = t("success.matter.link")
        redirect_to @matter and return
      end
      flash[:error] = t("error.matter.link")
      redirect_to @matter and return
    end
  end
  
  def find_ajax
    @matter = Matter.find(params[:id])
    @result = Hash.new
    @result[:query] =  params[:query]
    @result[:suggestions] = Array.new
    @result[:data] = Array.new
    index = 0
    @matters = Matter.where(['matters.id != ?', "#{@matter.id}"]).joins(:document).where(:matter_type_id => @matter.matter_type_id).all(:conditions => ['registration_number like ?', "%#{params[:query]}%"])    
    @matters.each do |matter|
      @result[:suggestions][index] = matter.document.registration_number
      @result[:data][index] = matter.id
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
  
end
