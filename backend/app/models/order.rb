class Order < ApplicationRecord
  after_create :stream_notification

  enum status: %i[received waiting in_progress finished completed]

  belongs_to :table
  has_many :items

  after_commit :order_received!, on: :create

  private

  def stream_notification
    message_data = {
      status: self.status,
      table: self.table.number,
    }

    ActionCable.server.broadcast("orders_channel", message_data)
  end

  def order_received!
    OrderPublisher.publish('order.received', attributes.slice('id', 'status'))
  end
end
