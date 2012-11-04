atom_feed do |feed|
  feed.language "fa_IR"
  feed.title("")
  feed.updated Story.maximum(:created_at)

  @stories.each do |story|
    feed.entry story, :published => story.publish_date do |entry|
      entry.title(story.title)
      entry.content(story.content)

      entry.author do |author|
        author.name story.user
      end
    end
  end
end