require 'spec_helper'
require 'faker'

describe UsersController do
  it "should creates a user successfully" do
    post :create, user_full_name: "full_name", user_email: "user@example.com"
    # pp assigns[:user]
  end
end
