require 'spec_helper'

describe "StaticPages" do

  subject { page }
  # Home page
  describe "Home page" do

    before { visit root_path }

    it { should have_selector('h1', text: 'Demo')}
    it {  should have_selector('title',
                                :text => full_title('home')) }

    it "should have the right links on the layout" do
      visit root_path
      click_link 'About'
      page.should have_selector('title', text: full_title('About'))
      click_link 'Help'
      page.should have_selector('title', text: full_title('Help'))
      click_link 'Contact'
      page.should have_selector('title', text: full_title('Contact'))
      click_link 'Home'
      page.should have_selector('title', text: full_title('home'))
      click_link 'Sign up now!'
      page.should have_selector('title', text: full_title('sign up'))
    end
    describe "for signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "first")
        FactoryGirl.create(:micropost, user: user, content: "second")
        sign_in user
        visit root_path
      end
      it { should have_content('Micropost Feed') }
      it "show users' microposts" do
        user.feed.each do |m|
          page.should have_selector("li##{m.id}", text: m.content)
        end
      end
      

      describe "show follow info" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        it {  should have_link('0 following', href: following_user_path(user)) }
        it {  should have_link('1 followers', href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do

    before { visit help_path }
    
    it { should have_selector('h1', text: 'Help')}
    it {  should have_selector('title',
                                text: full_title('Help')) }
    
  end

  describe "About page" do

    before {visit about_path }
    
    it {  should have_selector('h1', text: 'About') }
    it {  should have_selector('title',
                                text: full_title('About')) }
  end

  describe "Contact page" do

    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
    it {  should have_selector('title', text: full_title('Contact')) }
    
  end
  
end
