class Order < ApplicationRecord
  enum status: %i[recebido em_preparacao pronto entregue]

  belongs_to :table
  belongs_to :product
end
