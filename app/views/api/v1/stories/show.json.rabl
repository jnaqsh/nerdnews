object @story
attributes :id, :title, :total_point, :hide, :comments_count, :view_counter, :positive_votes_count,
  :negative_votes_count

node :content do |story|
  RedCloth.new(story.content, [:filter_html, :filter_styles]).to_html
end

node :published_at do |story|
  to_jalali(story.publish_date) if story.approved?
end

node :author do |story|
  user_name(story, true)
end

node :author_avatar do |story|
  avatar_url story.user
end

node :reference_url do |story|
  story.source
end

node :story_url do |story|
  story_url(story)
end

child :comments do
  attributes :id, :name, :positive_votes_count, :negative_votes_count, :total_point

  node :content do |comment|
    comment.content
  end
end

child :tags do
  attributes :id, :name

  node :url do |tag|
    stories_url tag: tag.name
  end

  node :thumbnail_url do |tag|
    tag.thumbnail.url :thumb
  end
end
