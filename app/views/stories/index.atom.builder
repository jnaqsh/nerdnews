atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
      'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.language "fa_IR"
  feed.title("نردنیوز")
  feed.updated Story.maximum(:created_at)

  @stories.each do |story|
    feed.entry story, :published => story.publish_date do |entry|
      entry.title(story.title)
      entry.content :type => 'xhtml' do |xhtml|
        xhtml.p "dir" => 'rtl' do
          xhtml.p << sanitize(RedCloth.new(story.content).to_html)
          unless story.source.blank?
            xhtml.a "منبع اصلی خبر", "href" => story.source, "target" => "_blank"
          end
        end

        if story.comments_count > 0 and story.comments.approved
          xhtml.hr
          xhtml.p "dir" => "rtl" do
            xhtml.b "دیدگاه‌ها:"
          end
          story.comments.approved.each do |comment|
            xhtml.p "dir" => "rtl" do
              xhtml.b comment.name + ' <' + to_jalali(comment.created_at) + '>'
            end
            xhtml.p comment.content, "dir" => "rtl"
          end
        end
      end

      entry.author { |author| author.name(user_name(story, true))}
    end
  end
end
