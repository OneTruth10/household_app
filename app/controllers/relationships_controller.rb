class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # When following
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_back(fallback_location: root_path, notice: "#{user.display_name} をフォローしました！")
  end

  # When unfollowing
  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_back(fallback_location: root_path, notice: "#{user.display_name} のフォローを解除しました。")
  end
end