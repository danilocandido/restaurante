# frozen_string_literal: true

class BunnyClient
  class << self
    # Cria a conexão com o RabbitMQ
    def connect!
      attrs = { host: 'rabbitmq', vhost: '/', user: 'guest', pass: 'guest' }
      # Utiliza a variável CLOUDAMQP_URL para conectar no host indicado
      @connection = Bunny.new(attrs)
      @connection.start
      # Cria o canal
      @channel = @connection.create_channel
      # Cria nossa fila para onde vamos publicar as mensagens
      @exchange_fan_out = @channel.topic('order.received', auto_delete: true)

      @channel.queue('kitchen')

      @connected = true
    end

    # Publica as mensagens na fila, informando a origem da app
    def push(payload)
      connect! unless @connected
      @exchange_fan_out.publish(payload, { app_id: 'order_received' })

      true
    end
  end
end