require 'spec_helper'

describe Relationship do
  let(:follower) {FactoryGirl.create(:user)}
  let(:followed){FactoryGirl.create(:user)}
  let(:relationship) {follower.relationships.build(followed_id: followed.id)}
  subject {relationship}
  it {should be_valid}
  it "should not allow access follower_id" do
    expect {Relationship.new(follower_id: follower.id)}.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
  describe "follower methods" do
    its(:follower) {should == follower}
    its(:followed) {should == followed}
    it {should respond_to(:follower)}
    it {should respond_to(:followed)}
  end
  describe "present validation" do
    it "should not presend of followed_id" do
      relationship.follower_id = nil
      relationship.should be_invalid
    end
    it "should not present of follower_id" do
      relationship.followed_id = nil
      relationship.should be_invalid
    end
  end
end
