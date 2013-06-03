require 'spec_helper'

describe "StaticPages" do

  # Home page
  describe "Home page" do
    
    it "should have content Demo" do
      visit '/static_pages/home'
      page.should have_selector('h1', 'Demo')
    end

    it "should have title 'home' " do
      visit '/static_pages/home'
      page.should have_selector('title',
                                :text => "Demo | home")
    end
  end

  describe "Help page" do

    before { visit static_pages_help_path }
    it "should have content 'help' " do
      page.should have_selector('h1', 'Help')
    end

    it "should have title 'help' " do
      page.should have_selector('title',
                                text: "Demo | Help")
    end
    
  end

  describe "About page" do

    before {visit '/static_pages/about' }
    it "should have content About" do
      page.should have_selector('h1', 'About')
    end

    it "should have title 'About'" do
      page.should have_selector('title',
                                text: 'Demo | About')
    end
  end
end
