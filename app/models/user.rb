class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true
  has_secure_password
	validates :terms_of_service, acceptance: true


end
