class MessagesController < ApplicationController
  wrap_parameters false
  include RedisModule
	before_action :set_chat
	before_action :set_message, only: [:show, :update]


  def create
    @new_message=@chat.messages.build
    @new_message.number = RedisModule.get_new_number(@redis_key)
    @new_message.body=message_params[:body]
    if @new_message.valid?
      MessageCreatePublisher.publish(@new_message)
      json_response({
      "chat_number"=>@chat.number,
      "message_number"=>@new_message.number,
      "body"=>@new_message.body
    },:created)
    else 
      json_response(@new_message.errors,:unprocessable_entity)
    end
  end

  def show
    json_response({
      "chat_number"=>@chat.number,
      "message_number"=>@message.number,
      "body"=>@message.body,
      "created_at"=>@message.created_at,
      "updated_at"=>@message.updated_at
    })
  end

  def update
    @new_params=message_params.to_unsafe_h
    @new_params.delete :app_token
    @new_params.delete :chat_number
    @new_params.delete :controller
    @new_params.delete :action
    @message.update(@new_params)
    head :no_content
  end

  private

  def message_params
    params.permit(:app_token,:body,:chat_number)
  end

  def set_message
    @message = @chat.messages.find_by!(number: params[:number]) or not_found
  end

  def set_chat
  	@chat = Chat.joins(:application).where(application: {app_token: params[:app_token]}).where(chats: {number: params[:chat_number]}).first  or not_found
    @redis_key = "#{params[:app_token]}_chat_number_message_#{params[:chat_number]}_key"
  end
end
