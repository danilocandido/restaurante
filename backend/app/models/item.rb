class Item < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # accepts_nested_attributes_for :order, :product
end
