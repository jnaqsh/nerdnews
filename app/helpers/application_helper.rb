module ApplicationHelper
  def list_tags(tags)
    h = {}
    tags.each do |tag|
      h[tag.name] = tag.percentage_of_tag
    end
    return h
  end
end
