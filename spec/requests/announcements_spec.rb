# encoding: utf-8

require 'spec_helper'

describe "Announcements" do
  it 'displays active announcements', js: true do
    Announcement.create! message: "Hello world!", starts_at: 10.hour.ago, ends_at: 1.day.from_now
    Announcement.create! message: "Upcoming", starts_at: 10.minutes.from_now, ends_at: 1.hour.from_now
    visit root_path
    page.should have_content("Hello world!")
    page.should_not have_content("Upcoming")
    click_link "hide_announcement"
    page.should_not have_content("Hello world!")
  end

  it 'stays on page when hiding annoucement with javascript', js: true do
    Announcement.create! message: "Hello world!", starts_at: 1.hour.ago, ends_at: 1.hour.from_now
    visit root_path
    page.should have_content("Hello world!")
    expect {click_link "hide_announcement"}.to_not change {page.response_headers}
    page.should_not have_content("Hello world!")
  end
end
