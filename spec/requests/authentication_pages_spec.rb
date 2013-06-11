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
      before { sign_in user }
      it { should  have_selector('title', text: user.name)}
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path)}
    end
  end
  describe "authentication" do
    let(:user) { FactoryGirl.create(:user) }    
    describe "for non-signin" do
      it "edit action" do
        visit edit_user_path(user)
        page.should have_selector('title', text: 'Sign in')
      end
      it "update action" do
        put user_path(user)
        response.should redirect_to signin_path
      end
      it "should go the page before he sign-in when he sign-in" do
        visit edit_user_path(user)
        sign_in user
        page.should have_selector('title', text: 'Edit user')
      end
    end
    describe "for signin user" do
      before { sign_in user }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@gmail.com") }
      it "can not edit other profile" do
        visit edit_user_path(wrong_user)
        page.should_not have_selector('title', text: 'Edit user')
      end
      it "can not put other profile" do
        put user_path(wrong_user)
        response.should redirect_to signin_path
      end
      describe "for non-admin user" do
        before { visit users_path }
        it { should_not have_link('delete')  }
        it "should not execute destroy action" do
          delete user_path(user)
          response.should redirect_to root_path
        end
      end
      describe "for admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          FactoryGirl.create(:user, email: "another_user@gmail.com")
          visit users_path
        end
        it { admin.should be_admin }
        it { admin.admin == true }
        it { should have_link('delete', href: user_path(User.last)) }
        it "should be able to delete another user" do
          expect{ click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end
