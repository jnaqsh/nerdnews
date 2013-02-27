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

  def to_jalali(date, options = {})
    jalali_date = JalaliDate.new(date)
    if options[:standard]
      jalali_date.strftime("%e %b %Y").to_farsi
    elsif options[:just_time]
      "ساعت " + jalali_date.strftime("%H:%M").to_farsi
    else
      jalali_date.strftime("%A %e %b %Y - %H:%M").to_farsi
    end
  end

  def nested_comments(messages)
    if messages && messages.count > 0
      messages.map do |message, sub_messsages|
        render(message) + content_tag(:div, nested_comments(sub_messsages), class: "nested_comments")
      end.join.html_safe
    else
      return nil
    end
  end

  def user_name(object, plain=false)
    if object.user
      unless plain
        link_to object.user.full_name, user_path(object.user)
      else
        object.user.full_name
      end
    else
      t('helpers.application.anonymous_user')
    end
  end

  def source_of_story(story)
    if story && story.source
      link_to "منبع اصلی خبر", story.source, target: "_blank"
    end
  end

  def sign_message(message)
    signed = " "
    signed += link_to message.sender.full_name, user_path(message.sender)
    signed += " " + to_jalali(message.created_at)
    signed += " به " + link_to(message.receiver.full_name, user_path(message.receiver))
    signed.html_safe
  end

  def body(&block)
    content_tag :body, class: determine_browser_and_os do
      capture(&block)
    end
  end

  private
  # The ruby version of the CSS Browser Selector with some additions
  # This code is from: https://github.com/attinteractive/css_browser_selector
  def determine_browser_and_os(ua = request.env["HTTP_USER_AGENT"])
    ua = (ua||"").downcase
    br = case ua
      when /opera[\/,\s+](\d+)/
        o = %W(opera opera#{$1})
        o << "mobile" if ua.include?('mini')
        o.join(" ")
      when /webtv/ ;              "gecko"
      when /msie (\d)/ ;          "ie ie#{$1}"
      when %r{firefox/2} ;        "gecko ff2"
      when %r{firefox/3.5} ;      "gecko ff3 ff3_5"
      when %r{firefox/3} ;        "gecko ff3"
      when /konqueror/ ;          "konqueror"
      when /applewebkit\/([\d.]+).? \([^)]*\) ?(?:version\/(\d+))?.*$/
        o = %W(webkit)
        if ua.include?('iron')
          o << 'iron'
        elsif ua.include?('chrome')
          o << 'chrome'
        else
          o << "safari safari"+ ($2 || (($1.to_i >= 400) ? '2' : '1'))
        end
        o.join(" ")
      when /gecko/, /mozilla/ ;   "gecko"
    end
    os = ua.include?('mac') || ua.include?('darwin') ? ua.include?('iphone') ? 'iphone' : ua.include?('ipod') ? 'ipod' : 'mac' :
         ua.include?('x11') || ua.include?('linux') ? 'linux' :
         ua.include?('win') ? 'win' : nil
    "#{br}#{" " unless br.nil? or os.nil?}#{os}"
  end
end
