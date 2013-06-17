require 'spec_helper'

describe "MicropostPages" do
  subject {page}
  describe "index page" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      FactoryGirl.create(:micropost, user: user, content: "haha")
      sign_in user
      visit root_path
    end
    it "with invalid information" do
      expect {click_button "Post"}.not_to change(Micropost, :count)
      click_button "Post"
      page.should have_content('error')
    end
    it "with valid information" do
      fill_in "micropost_content", with: "first micropost"
      expect {click_button "Post"}.to change(Micropost, :count).by(1)
    end
    it "should delete micropost" do
      expect { click_link('delete') }.to change(Micropost, :count).by(-1)
    end
  end
end
