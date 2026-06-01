class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Validations
  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :occupation, length: { maximum: 100 }, allow_blank: true
end
