require 'spec_helper'

describe IdentitiesController do

  describe "GET 'create'" do
    it "returns http success" do
      visit 'create'
      response.should be_success
    end
  end

end
