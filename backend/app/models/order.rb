class Order < ApplicationRecord
  enum status: %i[received waiting in_progress finished completed]

  belongs_to :table
  has_many :items

  after_commit :order_received!, on: :create
  after_commit :stream_notification, on: :create

  private

  def stream_notification
    message_data = {
      id: id,
      status: self.status,
      table: self.table.number,
    }

    ActionCable.server.broadcast("orders_channel", message_data)
  end

  def order_received!
    OrderPublisher.publish('order.received', attributes.slice('id', 'status'))
  end
end
