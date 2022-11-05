class MessageCreatePublisher
  MESSAGE_QUEUE_NAME = 'instabug.message.create'.freeze
  def self.publish(message = {})
    channel = RabbitQueueService.connection.create_channel
    queue=channel.queue(MESSAGE_QUEUE_NAME,durable: true)
    queue.publish(message.to_json,persistent: true)
  end
end