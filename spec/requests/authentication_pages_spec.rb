require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "sign in" do
    before { visit signin_path }
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }

    let(:signin) {  "Sign in"}
    describe "with invalid information" do
      before { click_button signin }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { should have_selector('title', text: 'Sign in') }
      it "should not show flash again" do
        click_link "Home"
        page.should_not have_selector('div.alert.alert-error')
      end
    end
    describe "with valid information" do
      let (:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button('Sign in')
      end
      it { should  have_selector('title', text: user.name)}
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it "when click the sign out" do
        click_link('Sign out')
        page.should have_link('Sign in', href: signin_path)
      end

    end
  end
end
