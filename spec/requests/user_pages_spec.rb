require 'spec_helper'

describe "UserPages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }  
  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1', text: 'sign up') }
    it { should have_selector('title', text: full_title('sign up')) }
    let(:submit) { "Create my account" }
    it "with invalid information" do
      expect { click_button submit }.not_to change(User, :count)
    end
    it "with valid information" do
      fill_in "Name", with: user.name
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Confirmation", with: user.password_confirmation
      expect { click_button submit }.to change(User, :count).by(1)
    end
  end

  describe "profile page" do

    before { visit user_path(user) }
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end


