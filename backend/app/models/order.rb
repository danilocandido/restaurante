class Order < ApplicationRecord
  enum status: %i[received waiting in_progress finished completed]

  belongs_to :table
  has_many :items

  after_commit :order_received!, on: :create
  after_commit :stream_notification, on: :create

  def self.most_recent
    Order.select('orders.id, orders.status, orders.table_id, tables.number AS table_number')
     .joins(:table)
     .where(status: %i[waiting in_progress])
  end

  private

  def stream_notification
    message_data = {
      id: id,
      status: status,
      table: table.number
    }

    ActionCable.server.broadcast("orders_channel", message_data)
  end

  def order_received!
    OrderPublisher.publish('order.received', attributes.slice('id', 'status'))
  end
end
