require 'spec_helper'

describe Announcement do
  it "has current scope" do
    passed = Announcement.create! message: "Hello world!", starts_at: 1.day.ago, ends_at: 1.hour.ago
    current = Announcement.create! message: "Hello world!", starts_at: 1.hour.ago, ends_at: 1.day.from_now
    upcoming = Announcement.create! message: "Hello world!", starts_at: 1.hour.from_now, ends_at: 1.day.from_now
    Announcement.current.should eq([current])
  end

  it "does not include ids passed in to current" do
    current1 = Announcement.create! message: "Hello world!", starts_at: 1.hour.ago, ends_at: 1.day.from_now
    current2 = Announcement.create! message: "Hello world!", starts_at: 1.hour.ago, ends_at: 1.day.from_now
    Announcement.current([current2.id]).should eq([current1])
  end

  it "includes current when nil is passed in" do
    current = Announcement.create! message: "Hello world!", starts_at: 1.hour.ago, ends_at: 1.day.from_now
    Announcement.current(nil).should eq([current])
  end
end
