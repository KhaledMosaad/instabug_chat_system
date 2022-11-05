class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :app_token, index: { unique: true, name: 'unique_token' },null: false
      t.string :name
      t.integer :chats_count
      t.timestamps
    end
  end
end
