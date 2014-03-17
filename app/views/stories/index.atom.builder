atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
      'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.title("نردنیوز")
  feed.updated Story.maximum(:created_at)

  @stories.each do |story|
    story_comments = story.comments.approved

    feed.entry story, :published => story.publish_date do |entry|
      entry.title(story.title)
      entry.content :type => 'xhtml' do |xhtml|
        xhtml.p "dir" => 'rtl' do
          xhtml.p << sanitize(RedCloth.new(story.content).to_html)
          unless story.source.blank?
            xhtml.a "منبع اصلی خبر", "href" => story.source, "target" => "_blank"
          end

          # Social Sharing Icons
          xhtml.p do
            xhtml.a href: "http://www.facebook.com/sharer.php?u=#{story_url(story)}", target: '_blank' do
              xhtml.img src: "#{image_path 'social-icons/fc-webicon-facebook-m.png'}", alt: "Google+"
            end

            xhtml.a href: "http://twitter.com/home?status=#{story.title} #{story_url(story)}", target: '_blank' do
              xhtml.img src: "#{image_path 'social-icons/fc-webicon-twitter-m.png'}", alt: "Google+"
            end

            xhtml.a href: "https://plus.google.com/share?url=#{story_url(story)}&hl=fa&subject=#{story.title}", target: '_blank' do
              xhtml.img src: "#{image_path 'social-icons/fc-webicon-googleplus-m.png'}", alt: "Google+"
            end
          end

        end

        if story.comments_count > 0 and story_comments
          xhtml.hr
          xhtml.p "dir" => "rtl" do
            xhtml.a href: story_url(story, anchor: "comments"), target: "_blank" do
              xhtml.b "دیدگاه‌ها: (#{story.comments_count.to_farsi})"
            end
          end
          story_comments.each_with_index do |comment, index|
            break if index == 5
            xhtml.p "dir" => "rtl" do
              xhtml.b comment.name + ' <' + to_jalali(comment.created_at) + '>'
            end
            xhtml.p "dir" => "rtl" do
              xhtml.p << sanitize(RedCloth.new(comment.content).to_html)
            end
          end
        end
      end

      entry.author { |author| author.name(user_name(story, true))}
    end
  end
end
