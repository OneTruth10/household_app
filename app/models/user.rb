class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :expenses, dependent: :destroy

  belongs_to :main_currency, class_name: "Currency", foreign_key: "main_currency_id"

  validates :username, uniqueness: true, allow_blank: true
end
