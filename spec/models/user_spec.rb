require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "example@example.com", password: "foobar", password_confirmation: "foobar") }
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships)}
  it { should respond_to(:followed_users)}
  it { should respond_to(:reverse_relationships)}
  it { should respond_to(:followers)}
  it { should respond_to(:following?)}
  it { should respond_to(:follow!)}
  it { should respond_to(:unfollow!)}
  it { should be_valid }
  it { should_not be_admin }

  describe "name validation " do
    it "should not be blank in name" do
      @user.name = "" 
      @user.should be_invalid 
    end
    it "should no more 51chars in mame" do
      @user.name = 'a' * 51
      @user.should be_invalid
    end
  end

  describe "email validation" do
    it "should not be blank of email" do
      @user.email = ""
      @user.should be_invalid
    end
    it "should have correct format of email" do
      addresses = %w[abc abc@ 123@]
      addresses.each do |addr|
        @user.email = addr
        @user.should be_invalid
      end
    end
    it "should not have email taken" do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
      @user.should be_invalid
    end
  end

  describe "password validation" do
    it "should not be blank" do
      @user.password = @user.password_confirmation = " "
      @user.should be_invalid
    end
    it "should not be mismatch" do
      @user.password_confirmation = "mistach"
      @user.should be_invalid
    end
    it "should not be nil" do
      @user.password_confirmation = nil
      @user.should be_invalid
    end
    it "should not less than 5 chars" do
      @user.password = @user.password_confirmation = 'a' * 5
      @user.should be_invalid
    end
  end

  describe "admin validation" do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end
  describe "authticate" do
    before { @user.save }
    let(:find_user) { User.find_by_email(@user.email) }
    it { should == find_user.authenticate(@user.password) }
    describe "with invalid password" do
      let(:user_with_invalid_password) { find_user.authenticate('mismatch') }
      it { should_not = user_with_invalid_password }
      it { user_with_invalid_password.should be_false }
    end
  end

  describe "remember_token validation" do
    before {@user.save  }
    it(:remember_token) { should_not be_blank  }
  end

  describe "should show microposts on the home page of user" do
    let(:other_user){ FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
      3.times { other_user.microposts.create!(content: "lorem ipsum") }
    end
    let!(:older_micropost) {  FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)}
    let!(:newer_micropost) {FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)}
    let!(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }

    its(:feed) {  should include(older_micropost) }
    its(:feed) {  should include(newer_micropost) }
    its(:feed) {  should_not include(unfollowed_post) }
    its(:feed) do
      other_user.microposts.each do |mic|
        should include(mic)
      end
    end
  end
  describe "follow user" do
    let(:other_user) {FactoryGirl.create(:user)}
    before do
      @user.save
      @user.follow!(other_user)
    end
    it {should be_following(other_user)}
    its(:followed_users) {should include(other_user)}
    it "followers" do
      other_user.followers.should include(@user)
    end
    it "unfollowing" do
      @user.unfollow!(other_user)
      @user.should_not be_following(other_user)
      @user.followed_users.should_not include(other_user)
    end
  end
end









