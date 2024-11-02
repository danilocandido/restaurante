require 'json'

class KitchenWorker
  include Sneakers::Worker

  # Configuração específica para o Sneakers
  # https://github.com/jondot/sneakers/blob/9780692624c666b6db8266d2d5710f709cb0f2e2/spec/sneakers/worker_spec.rb#L10
  from_queue 'order.received',
             :exchange_options => {
               :type => :topic,
               :durable => false,
               :auto_delete => true
             },
             :queue_options => {
               :durable => false
             },
             :ack => false,
             :heartbeat => 5,
             :exchange => 'orders_exchange',
             :timeout_job_after => 1

  def work(message)
    puts "KitchenWorker #{message}"
    payload = JSON.parse(message)
    order = Order.find(payload['id'])
    order.in_progress!

    logger.info 'Pedido Recebido'
    ack!
  end
end