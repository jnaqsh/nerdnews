class AddStoriesCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :stories_count, :integer, :default => 1
    add_column :tags, :stories_percentage, :integer, :default => 0

    Tag.find_each do |t|
      t.update_attribute :stories_count, t.stories.count
      t.update_attribute :stories_percentage, (t.stories.count.to_f / Tagging.count.to_f * 100).floor
    end
  end
end
