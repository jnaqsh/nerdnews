class UpdateCounterCacheOfCommentsOnStories < ActiveRecord::Migration
  def up
    Story.all.each do |story|
      Story.reset_counters(story.id, :comments)
    end
  end

  def down
  end
end
