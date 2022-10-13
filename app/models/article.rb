class Article < ApplicationRecord
    include(Visible)
    has_many :comments, dependent: :destroy
    belongs_to :user
    validates :title, presence: true, length: {minimum: 4}, uniqueness: true
    validates :content, presence: true, length: {minimum: 15}
end
