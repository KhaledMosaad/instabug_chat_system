class ChatCreatePublisher
  CHAT_QUEUE_NAME = 'instabug.chat.create'.freeze
  def self.publish(chat = {})
    channel = RabbitQueueService.connection.create_channel
    queue = channel.queue(CHAT_QUEUE_NAME, durable: true)
    queue.publish(chat.to_json,persistent: true)
  end
end