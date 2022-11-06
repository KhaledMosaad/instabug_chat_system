Rails.application.routes.draw do
  #resources :applications , only: :show :index :create :update do
   # resources :chats , only: :show :index :create :update do
    #  resources :messages , only: :show :index :create :update
    #end
  #end
  # application endpoints
  get '/applications/:app_token', to: 'applications#show'
  get '/applications/:app_token/chats', to: 'applications#index'
  post '/applications', to: 'applications#create'
  patch '/applications/:app_token', to: 'applications#update'
  # chats endpoints
  get '/chats/:number', to: 'chats#show'
  get '/chats/:app_token/:number/messages', to: 'chats#index'
  post '/chats', to: 'chats#create'
  patch '/chats/:number', to: 'chats#update' 
  get '/chats/:app_token/:number/search/:q', to: 'chats#search'
  # messages endpoints
  get '/messages/:app_token/:chat_number/:number', to: 'messages#show'
  post '/messages', to: 'messages#create'
  patch '/messages/:number', to: 'messages#update'


end
