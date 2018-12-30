class Tag < ApplicationRecord
  has_many :product_tags, inverse_of: :tag
  has_many :products, through: :product_tags

  validates :name, uniqueness: true, length: {minimum: 2}
end
