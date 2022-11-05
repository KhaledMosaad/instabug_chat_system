require 'elasticsearch/model'
class Chat < ApplicationRecord
  include Searchable
  belongs_to :application
  has_many :messages , dependent: :destroy
  validates :name , presence: true
  Chat.__elasticsearch__.create_index!
  Chat.__elasticsearch__.refresh_index!
end
