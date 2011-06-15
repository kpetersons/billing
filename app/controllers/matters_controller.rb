class MattersController < ApplicationController

  layout "matters"
  
  def index
    @matters = Matter.all
  end

  def new
    @document = Document.new(:parent_id => params[:matter_id])
    @document.matter = Matter.new
  end

  def create
    Document.transaction do
      @document = Document.new(params[:document])
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
    @matters = Matter.all
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
