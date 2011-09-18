class MessagesController < ApplicationController

  def new
    @message = Message.new(:user_id => current_user.id)
  end

  def create
    @message = Message.new(params[:message])
    Message.transaction do
      if @message.save
          redirect_to dashboard_index_path
      else
        render 'new'
      end
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    Message.transaction do
      if @message.update_attributes(params[:message])
        redirect_to dashboard_index_path
      else
        render 'edit'
      end
    end
  end

  def index
    @message = Message.last
  end
end
