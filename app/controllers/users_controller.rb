class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:q].present?
      #downcase the email
      search_email = params[:q].downcase
      @users = User.where("LOWER(email) = ?", search_email)
    else
      @users = User.none
    end
  end

  def followings
    @users = current_user.followings
  end
end
