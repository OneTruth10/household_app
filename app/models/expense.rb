class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  has_many :message, dependent: :nullify
end
