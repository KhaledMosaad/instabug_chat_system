require 'elasticsearch/model'
module Searchable
    extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
    indexes :id ,type: 'integer' 
    indexes :application_id, type: 'integer'
    indexes :number, type: 'integer'
    indexes :name, type: 'text'
    indexes :messages_count, type: 'integer'
    indexes :messages, type: 'nested' do
      indexes :body, type: 'text'
      indexes :number, type: 'integer'
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only:    [ :number, :messages_count, :name ,:id,:application_id],
      include: { messages: { only: [:body, :number] }}
    )
  end
    def self.search(options={},chat)
      q = "*#{options[:q]}*"
      __elasticsearch__.search({
        "query": {
          "bool":{
            "must":[
              {
               "nested": {
                    "path": "messages",
                      "query": {
                        "bool": {
                          "must": [
                            { 
                              "match": { 
                                "messages.body": q
                              } 
                            }
                          ]
                        }
                      }
                  }
                }
              ],
              "filter":[
                  {
                     "term": {
                        "number": chat.number
                      }
                  },
                  {
                     "term": {
                        "application_id": chat.application_id
                      }
                  }
              ]
            }
        }
      }
      )
    end
  end
end