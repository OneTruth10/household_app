class Relationship < ApplicationRecord
    #State follower_id and follwed_id are from user model
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User", foreign_key: "followed_id"

    validates :follower_id, presence: true
    validates :followed_id, presence: true
end
