require 'sneakers'
require 'redis'
require 'json'
require 'sneakers/metrics/logging_metrics'

attrs = { host: 'rabbitmq', vhost: '/', user: 'guest', pass: 'guest' }

Sneakers.configure(
  connection: Bunny.new(attrs),
  metrics: Sneakers::Metrics::LoggingMetrics.new,
  log: STDOUT
)

Sneakers.logger = Rails.logger
Sneakers.logger.level = Logger::INFO
