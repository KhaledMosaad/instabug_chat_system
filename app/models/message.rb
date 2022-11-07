require 'elasticsearch/model'
class Message < ApplicationRecord
  include Searchable
  belongs_to :chat
  validates :body , presence: true
  Message.__elasticsearch__.create_index!
  Message.__elasticsearch__.refresh_index!
end
