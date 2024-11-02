class Order < ApplicationRecord
  enum status: %i[received waiting in_progress finished completed]

  belongs_to :table
  has_many :items

  after_commit :order_received!, on: :create

  private

  def order_received!
    OrderPublisher.publish('order.received', attributes.slice('id', 'status'))
  end
end
