module ApplicationHelper
  def list_tags(tags)
    h = {}
    tags.each do |tag|
      h[tag.name] = tag.percentage_of_tag
    end
    return h
  end

  def avatar_url(user)
    gravater_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravater_id}.png?s=20"
  end

  def to_jalali(date)
    jalali_date = JalaliDate.new(date)
    jalali_date.strftime("%A %e %b %Y - %H:%M").to_farsi
  end
end
