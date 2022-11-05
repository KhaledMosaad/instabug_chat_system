require 'sneakers'
require 'sneakers/handlers/maxretry'
puts 'get into sneakers initializer'
module Connection
  def self.sneakers
    @_sneakers = begin
      Bunny.new(
        addresses: ENV['RABBITMQ_DEFAULT_HOST']&.split(','),
        username:  ENV['RABBITMQ_DEFAULT_USER'],
        password:  ENV['RABBITMQ_DEFAULT_PASS'],
        vhost:     '/',
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: (10_000).to_i
      )
    end
  end
end


Sneakers.configure  :connection => Connection.sneakers,
                    :daemonize => true,
                    :workers => 2,
                    :log => "log/sneakers.log",
                    :pid_path => 'tmp/pids/sneakers.pid',
                    :prefetch => 1,
                    :threads => 2,
                    :durable => true,
                    :ack => true,
                    :handler => Sneakers::Handlers::Maxretry,
                    :retry_max_times => 10,
                    :retry_timeout => 3 * 60 * 1000

Sneakers.logger = Rails.logger
Sneakers::Worker.logger = Rails.logger
