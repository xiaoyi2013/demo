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
  it { should be_valid }

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
end
