# Learn more: http://github.com/javan/whenever

every 1.day, :at => '2:00 am' do
  runner "Story.hide_negative_stories"
end