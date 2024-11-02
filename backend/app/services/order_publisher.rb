class OrderPublisher
  class << self
    def publish(routing_key, message = {})
      exchange = channel.topic('orders_exchange', auto_delete: true)
      exchange.publish(message.to_json, routing_key: routing_key)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      attrs = { host: 'rabbitmq', vhost: '/', user: 'guest', pass: 'guest' }
      @connection ||= Bunny.new(attrs).tap(&:start)
    end
  end
end
