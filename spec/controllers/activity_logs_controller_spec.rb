require 'spec_helper'

describe ActivityLogsController do

  describe "GET 'index'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      cookies.signed[:user_id] = user.id
      get 'index'
      response.should be_success
    end
  end

end
