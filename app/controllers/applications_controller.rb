class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update ,:index]

  def index
    @applicationchats = @application.chats.all.select(:'chats.number',
      :'chats.name',:'chats.created_at',
      :'chats.updated_at',
      :'chats.messages_count')
    json_response(@applicationchats)
  end

  def create
    @napplication = Application.create!(application_params)
    json_response({
      "app_token"=>@napplication.app_token,
      "name"=>@napplication.name,
      "updated_at"=>@napplication.updated_at,
      "created_at"=>@napplication.created_at,
      "chats_count"=>@napplication.chats_count
    }, :created)
  end

  def show
    json_response({
      "app_token"=>@application.app_token,
      "name"=>@application.name,
      "updated_at"=>@application.updated_at,
      "created_at"=>@application.created_at,
      "chats_count"=>@application.chats_count
    })
  end

  def update
    @application.update(application_params)
    head :no_content
  end

  private
  def application_params
    # whitelist params
    params.permit(:name)
  end

  def set_application
    @application = Application.find_by(app_token: params[:app_token])
  end
end
