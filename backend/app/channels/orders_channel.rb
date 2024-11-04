class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
