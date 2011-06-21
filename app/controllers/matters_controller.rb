class MattersController < ApplicationController

  layout "matters"
  
  def index
    @matters = Matter.joins(:document).where(:documents => {:user_id => current_user.id}).paginate(:page => params[:param_name])
    @other_matters = Matter.joins(:document).where("user_id != #{current_user.id}").paginate(:page => params[:param_name])
  end

  def new
    @document = Document.new(:parent_id => params[:matter_id])
    @document.matter = Matter.new
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
  
end
