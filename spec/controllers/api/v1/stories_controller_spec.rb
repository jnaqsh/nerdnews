require 'spec_helper'

describe Api::V1::StoriesController, focus: true do
  render_views

  context 'index' do

    let(:token) do
      double :accessible? => true,
             :scopes => [:public]
    end

    before(:each) do
      controller.stub(:doorkeeper_token) { token }
    end

    it 'sends a list of messages', solr: true do
      FactoryGirl.create_list(:approved_story, 10)
      Sunspot.commit

      get :index, :format => :json
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json.length).to eq(10)

    end

  end

end
