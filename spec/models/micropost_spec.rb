require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong
    @micropost = user.microposts.build(content: "first micropost")
  end
  subject { @micropost }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should be_valid }
  it "when user_is is not present" do
    @micropost.user_id = nil
    @micropost.should be_invalid
  end
  it "when content is not present" do
    @micropost.content = ""
    @micropost.should_not be_valid
  end
  it "content should not more than 140 chars" do
    @micropost.content = 'a' * 141
    @micropost.should_not be_valid
  end
  it "should not access user_id" do
    expect { Micropost.new(user_id: user.id) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  describe "associate micropost" do
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago) }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago) }
    before { @micropost.save }
    it { user.microposts.should == [@micropost, newer_micropost, older_micropost] }
    it "micropost associate delete" do
      microp = user.microposts.dup
      user.destroy
      microp.should_not be_empty
      microp.each do |mp|
        Micropost.find_by_id(mp.id).should be_nil
      end
    end
  end

end








