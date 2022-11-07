class ChatsController < ApplicationController
  wrap_parameters false
  include RedisModule
	before_action :set_application
	before_action :set_chat, only: [:show, :update ,:index,:search]
  def index
    @chatmessages = @chat.messages.all.select(
      :'messages.number',
      :'messages.body',
      :'messages.created_at',
      :'messages.updated_at')
    json_response(@chatmessages)
  end

  def create
    @new_chat= @application.chats.build
    @new_chat.number = RedisModule.get_new_number(@redis_key)

    @new_chat.name = chat_params[:name]
    if @new_chat.valid?
      ChatCreatePublisher.publish(@new_chat)
    json_response({
      "name"=>@new_chat.name,
      "messages_count"=>@new_chat.messages_count,
      "chat_number"=>@new_chat.number
    }, :created)
    else
      json_response(@new_chat.errors,:unprocessable_entity)
    end
  end

  def show
    json_response({
      "name"=>@chat.name,
      "updated_at"=>@chat.updated_at,
      "created_at"=>@chat.created_at,
      "messages_count"=>@chat.messages_count,
      "chat_number"=>@chat.number
    })
  end

  def update
    @new_params=chat_params.to_unsafe_h
    @new_params.delete :app_token
    @new_params.delete :controller
    @new_params.delete :action
    @chat.update(@new_params)
    head :no_content
  end


  private
  def chat_params
    params.permit(:name,:app_token)
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:number]) or not_found
  end

  def set_application
  	@application=Application.find_by!(app_token: params[:app_token])  or not_found
    @redis_key="#{@application.app_token}_chat_number_key"
  end
end
