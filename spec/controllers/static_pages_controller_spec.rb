require 'spec_helper'

describe StaticPagesController do

  describe "GET 'faq'" do
    it "returns http success" do
      get 'faq'
      response.should be_success
    end
  end

end
