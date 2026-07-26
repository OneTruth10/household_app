class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms.order(updated_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages.order(created_at: :asc) # 💡メッセージはupdated_atではなく作成順(created_at)に並べるのが綺麗です
      @message = Message.new
    else
      redirect_to rooms_path, alert: "You are not in this room"
    end
  end

  def new
    @room = Room.new
    @friends = User.all.select { |user| current_user.mutual_following?(user) }
  end

  def create
    invited_user_ids = Array(params[:user_ids]).map(&:to_i).reject{|id| id == current_user.id}
    custom_room_name = params[:room_name].presence
    # 💡 1対1（招待された相手が1人）の場合、すでにその人との部屋があるかチェック
    if invited_user_ids.length == 1 && custom_room_name.present?
      puts "Creation has been called"
      partner_id = invited_user_ids.first
      
      # 自分が参加している部屋のID一覧を取得
      my_room_ids = current_user.entries.pluck(:room_id)
      
      # 相手も参加しているEntry（＝2人が共通して入っている既存の部屋）を探す
      common_entry = Entry.join
                          .find_by(
                                  user_id: partner_id, 
                                  room_id: my_room_ids,
                                  rooms: {name: custom_room_name}
                                  )
      
      if common_entry
        redirect_to room_path(common_entry.room_id) and return
      end
    end

    if custom_room_name.present?
      room_name = custom_room_name
    else
      names = invited_user_ids.map {|id| User.find(id).display_name}
      room_name = names.join(", ")
    end

    ActiveRecord::Base.transaction do 
      @room = Room.create!(name: room_name)

      Entry.create!(user_id: current_user.id, room_id: @room.id)
      invited_user_ids.each do |id|
        Entry.create!(user_id: id, room_id: @room.id)
      end
    end
    
    redirect_to room_path(@room), notice: "Created a chat"
  rescue => e
    logger.error "Chat creation error: #{e.message}"
    redirect_to rooms_path, alert: "Failed to create a chat: #{e.message}"
  end
end