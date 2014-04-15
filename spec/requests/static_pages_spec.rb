require 'spec_helper'

describe "Static Pages" do
  let (:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home Page" do
    it "should have the content 'Sample App'" do
      visit static_pages_home_path
      expect(page).to have_content('Sample App')
    end

    it "home should have the right title" do
      visit static_pages_home_path
      expect(page).to have_title("#{base_title}")
    end

    it "should not have a custom page title" do
      visit static_pages_home_path
      expect(page).to_not have_title("| Home")
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit static_pages_help_path
      expect(page).to have_content("Help")
    end

    it "help should have the right title" do
      visit static_pages_help_path
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit static_pages_about_path
      expect(page).to have_content("About Us")
    end

    it "about should have the right title" do
      visit static_pages_about_path
      expect(page).to have_title("#{base_title} | About")
    end
  end

  describe "Contact page" do
    it "should have the content 'Contact Us'" do
      visit static_pages_contact_path
      expect(page).to have_content("Contact Us")
    end

    it "should have the right title" do
      visit static_pages_contact_path
      puts page.title
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end
