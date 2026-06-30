class MessagesController < ApplicationController
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

  private
  def message_params
    params.require(:message).permit(:content)
  end
end
