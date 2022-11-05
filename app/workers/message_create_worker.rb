class MessageCreateWorker
  require 'json'
  include Sneakers::Worker
  QUEUE_NAME = MessageCreatePublisher::MESSAGE_QUEUE_NAME
  from_queue QUEUE_NAME,
             :env => nil,
             :ack => true,
             :durable => true

  def work(msg)
    begin
        data = ActiveSupport::JSON.decode(msg)
        message = Message.new(data)
        message.save!
        ack!
    rescue StandardError => e
      create_log(false, data, { message: e.message })
      reject!
    end
  end

  private
  def create_log(success, payload, message = {})
    message = {
      success: success,
      payload: payload
    }.merge(message).to_json

    severity = success ? :info : :error
    Rails.logger.send(severity, message)
  end
end