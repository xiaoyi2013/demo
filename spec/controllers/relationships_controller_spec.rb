require 'spec_helper'

describe RelationshipsController do
  let(:user){ FactoryGirl.create(:user) }
  let(:other_user){ FactoryGirl.create(:user) }
  before{ sign_in user }
  describe "create a relationship with ajax" do
    it "should increment the relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end
    it "should create a relationship successfully" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      response.should be_success
    end
  end
  describe "destroy a relationship with ajax" do
    before { user.follow!(other_user) }
    let(:relationship){ user.relationships.find_by_followed_id(other_user.id) }
    it "should decrease the relationship count" do
      expect do
        xhr :post, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end
    it "should destroy a relationship successfully" do
      xhr :post, :destroy, id: relationship.id
      response.should be_success
    end  
  end  
end  
