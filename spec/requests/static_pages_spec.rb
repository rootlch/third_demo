require 'spec_helper'

describe "Static Pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home Page" do
    before { visit root_path }
    let(:heading) { "Sample App" }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title("| Home") }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Hello world")
        FactoryGirl.create(:micropost, user: user, content: "goodbye")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should not display delete links for micropost not created by this user" do
        user.feed.each do |item|
          if item.user != user 
            expect(page).to_not have_selector("li##{item.id}", text: "delete")
          end
        end
      end

      it { should have_content("#{user.microposts.count} microposts") }
      it { should_not have_selector("div.pagination") }

      describe "more than 30 microposts" do
        before do
          30.times do
            FactoryGirl.create(:micropost, user: user, content: "test")
          end
          visit root_path
        end

        it { should have_selector("div.pagination") }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { "Help" }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact Us' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title("About"))
    click_link "Help"
    expect(page).to have_title(full_title("Help"))
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Sign up"))
    click_link "sample app"
    expect(page).to have_title(full_title(""))
  end
end
