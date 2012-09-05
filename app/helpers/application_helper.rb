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
    "http://gravatar.com/avatar/#{gravater_id}.png?s=#{size}"
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
end
