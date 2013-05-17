atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
      'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.language "fa_IR"
  feed.title("نردنیوز")
  feed.updated Story.maximum(:created_at)

  @stories.each do |story|
    feed.entry story, :published => story.publish_date do |entry|
      entry.title(story.title)
      source_link = story.source.blank? ? "" : '<br />" منبع اصلی خبر":' + story.source
      content = story.content +  source_link
      entry.content(sanitize(RedCloth.new(content).to_html), type: 'html')

      entry.author { |author| author.name(user_name(story, true))}
    end
  end
end
