#encoding: utf-8

module ApplicationHelper
  # def list_tags(tags)
  #   h = {}
  #   tags.each do |tag|
  #     h[tag.name] = tag.percentage_of_tag
  #   end
  #   return h
  # end

  def avatar_url(user, size = 20)
    gravater_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravater_id}.png?s=#{size}&d=mm"
  end

  def to_jalali(date)
    jalali_date = JalaliDate.new(date)
    jalali_date.strftime("%A %e %b %Y - %H:%M").to_farsi
  end

  def nested_comments(messages)
    messages.map do |message, sub_messsages|
      render(message) + content_tag(:div, nested_comments(sub_messsages), class: "nested_comments")
    end.join.html_safe
  end

  def user_name(story)
    if story.user
      link_to story.user.full_name, user_path(story.user)
    else
      t('.anonymous_user')
    end
  end

  def source_of_story(story)
    if story && story.source
      link_to "منبع اصلی خبر", story.source
    end
  end
end
