class AddThumbnailToTags < ActiveRecord::Migration
  def self.up
    add_attachment :tags, :thumbnail
  end

  def self.down
    remove_attachment :tags, :thumbnail
  end
end
