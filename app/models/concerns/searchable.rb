require 'elasticsearch/model'
module Searchable
    extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "search_message_index"
    mapping do
    indexes :number, type: 'integer'
    indexes :body, type: 'text'
    indexes :chat_id, type: 'integer'
  end
  def as_indexed_json(options={})
    self.as_json(
      only: [:number, :body, :chat_id]
    )
  end
    def self.search(options={},chat)
      q = "*#{options[:q]}*"
      __elasticsearch__.search({
        "query": {
          "bool":{
            "must":[
              "match": { 
                  "body": q
                }
              ],
              "filter":[
                  {
                     "term": {
                        "chat_id": chat.id
                      }
                  }
              ]
            }
        },
        '_source': ['body','number']
      }
      )
    end
  end
end