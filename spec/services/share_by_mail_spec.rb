describe ShareByMail do
  let(:user) { FactoryGirl.create(:user) }

  context "Validation" do
    subject { ShareByMail.new(user) }

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:reciever)}
  end
end