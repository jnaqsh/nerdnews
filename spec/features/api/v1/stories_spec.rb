require 'spec_helper'

describe Api::V1::StoriesController, solr: true do
  it 'sends a list of messages' do
    FactoryGirl.create_list(:approved_story, 10)
    Sunspot.commit

    visit '/api/v1/stories.json'

    json = JSON.parse(page.body)
    expect(json.length).to eq(10) # check to make sure the right amount of messages are returned
  end
end