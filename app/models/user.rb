class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :expenses, dependent: :destroy
  
  #active relationship
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  #passive relationship
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  belongs_to :main_currency, class_name: "Currency", foreign_key: "main_currency_id"
  after_initialize :set_default_main_currency
  validates :username, uniqueness: true, allow_blank: true

  def display_name
    username.present? ? username : email
  end

  def follow(other_user)
    followings << other_user unless self==other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def set_default_main_currency
    # main_currency_id がまだ空（nil）の場合だけ初期値をセットする
    if self.main_currency_id.blank?
      # 本番環境で万が一Currencyが空でも落ちないようにセーフティをかけます
      default_currency = Currency.find_by(code: 'JPY') || Currency.first
      
      if default_currency
        self.main_currency_id = default_currency.id
      end
    end
  end
end
