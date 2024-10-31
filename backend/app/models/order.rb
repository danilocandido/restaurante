class Order < ApplicationRecord
  enum status: %i[recebido em_preparacao pronto entregue]

  belongs_to :table
  has_many :items
end
