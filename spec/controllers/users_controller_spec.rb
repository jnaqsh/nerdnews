require 'spec_helper'
require 'faker'

describe UsersController do
  it "should creates a user successfully" do
    post :create, user: { full_name: "full_name", email: "user@example.com" }
    assigns(cookies[:user_id])
  end
end
