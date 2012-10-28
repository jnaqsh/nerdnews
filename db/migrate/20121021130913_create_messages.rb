class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :reciver_id
      t.string :subject
      t.text :message
      t.boolean :unread, default: true

      t.timestamps
    end
  end
end
