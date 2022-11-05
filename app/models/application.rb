class Application < ApplicationRecord
	has_many :chats , dependent: :destroy
	validates :name , presence: true
	before_create :set_uuid
  def set_uuid
    self.app_token = SecureRandom.uuid
  end
  
end
