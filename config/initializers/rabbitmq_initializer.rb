class RabbitQueueService
  def self.logger
    Rails.logger.tagged('bunny') do
      @@_logger ||= Rails.logger
    end
  end

  def self.connection
    @@_connection ||= begin
      instance = Bunny.new(
        addresses: ENV['RABBITMQ_DEFAULT_HOST'].split(','),
        username:  ENV['RABBITMQ_DEFAULT_USER'],
        password:  ENV['RABBITMQ_DEFAULT_PASS'],
        vhost:     '/',
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: 10_000.to_i,
        logger: RabbitQueueService.logger
      )
      instance.start
      instance
    end
  end
end