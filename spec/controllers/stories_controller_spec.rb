require 'spec_helper'

describe StoriesController, "GET RSS feed" do
  it "returns an RSS feed" do
    get :index, format: "atom"
    response.should be_success
    response.should render_template("stories/index")
    response.content_type.should eq("application/atom+xml")
  end
end