class MessagesController < ApplicationController
  before_action :set_room
  before_action :set_message, only: [:destroy, :edit, :update]
  before_action :check_user, only: [:destroy, :edit, :update]
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      redirect_to room_path(@room)
    else
      @messages = @room.messages.order(updated_at: :asc)
      render "rooms/show", status: :unprocessable_entry
    end
  end

  def destroy
    @message.destroy
    puts "deleted"
    redirect_to room_path(@room), notice: "Deleted message."
  end

  def edit
  end

  def update
    @message.content = message_params[:content]
    if @message.save
      redirect_to room_path(@room), status: :see_other
    else
      redirect_to room_path(@room), 
                  status: :unprocessable_entity,
                  alert: "Unable to edit: #{@message.errors.full_messages.join(', ')}"
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :expense_id)
  end
  
  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_message
    @message = @room.messages.find(params[:id])
  end

  def check_user
    unless @message.user_id == current_user.id
      redirect_to room_path(@room), alert: "This is not your message."
    end
  end
end
