atom_feed do |feed|
  feed.language "fa_IR"
  feed.title("نردنیوز")
  feed.updated Story.maximum(:created_at)

  @stories.each do |story|
    feed.entry story, :published => story.publish_date do |entry|
      entry.title(story.title)
      entry.content(sanitize(RedCloth.new(story.content, [:filter_html, :filter_styles]).to_html), type: 'html')

      entry.author { |author| author.name(user_name(story, true))}
    end
  end
end
