class CreateStoriesRatings < ActiveRecord::Migration
  def change
    create_table :stories_ratings do |t|
      t.integer :user_id
      t.integer :story_id
      t.integer :rating_id

      t.timestamps
    end
  end
end
