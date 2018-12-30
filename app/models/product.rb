class Product < ApplicationRecord
  has_many :product_tags, inverse_of: :product
  has_many :tags, through: :product_tags

  validates_presence_of :name, :price
  validate :min_word_count
  accepts_nested_attributes_for :tags,
                                allow_destroy: true,
                                reject_if: proc {|att| att['name'].blank?}

  private

  def min_word_count
    raise 'Name should contain minimum of 2 words.' if name.split.size < 2
  end

end
