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
      fill_in "Email", with: "example22@gmail.com"
      fill_in "Password", with: user.password
      fill_in "Confirmation", with: user.password_confirmation
      expect { click_button submit }.to change(User, :count).by(1)
      page.should have_link('Sign out', href: signout_path)
    end
  end

  describe "profile page" do
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "micropost1") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "micropost2") }

    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { visit user_path(other_user) }
      describe "following a user" do
        it "should increase the followed user count" do
          expect { click_button "Follow" }.to change(user.followed_users, :count).by(1)
        end
        it "should increase the other user's followers count" do
          expect { click_button "Follow" }.to change(other_user.followers, :count).by(1)
        end
        it "toggle the button" do
          click_button "Follow"
          page.should have_selector('input', value: "Unfollow")
        end
        
        describe "unfollow a user" do
          before do
            user.follow!(other_user)
            visit user_path(other_user)
          end
          it "should decrease the followed user count" do
            expect { click_button "Unfollow" }.to change(user.followed_users, :count).by(-1)
          end
          it "should decrease the other user's followers count" do
            expect { click_button "Unfollow" }.to change(other_user.followers, :count).by(-1)
          end
          it "toggle the button" do
            click_button "Unfollow"
            page.should have_selector('input', value: "Follow")
          end
        end
        
      end
      
    end
    
  end

  describe "following/followers page" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }
    
    describe "following page" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end
    
    describe "followers page" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      it { should have_selector('title', text: full_title('Followers'))}
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
  
  describe "edit page" do
    before do
      sign_in user
      visit edit_user_path(user)
    end
    it { should have_selector('title', text: 'Edit user') }
    it { should have_selector('h1', text: 'Update your profile') }
    it { should have_link('change', text: 'http://gravatar.com/emails') }
    let(:save) { "Save changes" }
    it "with invalid information" do
      click_button save
      page.should have_selector('title', text: 'Edit user')
    end
    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button save
      end
      it {  should have_selector('h1', text_name: new_name)}
      it { user.reload.name.should == new_name }
      it { user.reload.email == new_email }
    end
  end

  describe "index page" do
    
    it "should log-in" do
      visit users_path
      page.should have_selector('title', text: 'Sign in')
    end
    describe "show all users list" do
      before do
        sign_in user
        FactoryGirl.create(:user, name: "another", email: "another@example.com")
        FactoryGirl.create(:user, name: "haha", email: "haha@example.com")
        visit users_path
      end
      it {  should have_selector('title', text: 'All users') }
      it {  should have_selector('h1', text: 'All users') }
      it "should show all users" do
        User.all.each do |u|
          page.should have_selector('li', text: u.name)
        end
      end
      describe "paginatation" do
        before(:all) { 40.times {  FactoryGirl.create(:user)} }
        after(:all){ User.delete_all }
        before { visit users_path }
        it { should have_selector('div.pagination') }
        it "should list each all uers" do
          User.paginate(page: 1) do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end
    end
  end

end
