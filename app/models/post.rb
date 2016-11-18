class Post < ApplicationRecord
  validates :name, :presence => true

  validates :content, :presence => true
  validates :content, :length => { minimum: 20 }
end
