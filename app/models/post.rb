class Post < ApplicationRecord
  validates :name, :presence => true

  validates :content, :presence => true
  validates :content, :length => { minimum: 20 }

  belongs_to :category
  belongs_to :user

  has_many :comments
end
