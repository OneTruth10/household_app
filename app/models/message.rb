class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :expense, optional: true
  validates :content, presence: true, length: {maximum: 1000}, unless: -> { expense_id.present? }
end
