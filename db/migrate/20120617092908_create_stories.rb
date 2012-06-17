class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.text :content
      t.datetime :publish_date
      t.integer :user_id
      t.text :excerpt
      t.string :slug

      t.timestamps
    end
  end
end
