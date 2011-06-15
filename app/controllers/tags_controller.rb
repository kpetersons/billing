class TagsController < ApplicationController
    
  def add
    Tag.transaction do
      @document = Document.find(params[:document_id])
      tags = params[:tag][:name]
      tags.split(',').each do |tag_name|
        tag_name = tag_name.strip
        @tag = Tag.find_by_name(tag_name)
        if @tag.nil?
          @tag = Tag.create(:name => tag_name)
        end
        unless @document.tags.find_by_name(tag_name)
          @document.tags<<@tag
        end
      end
      redirect_to matter_path(@document.matter)
    end
  end

end
