require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content("Sign up") }
    it { should have_title(full_title("Sign up")) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "display error message" do
        before { click_button submit }

        it { should have_content("Email is invalid") }
        it { should have_content("Password is too short (minimum is 6 characters)") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after creating an account" do
        let (:welcome_msg) { "Welcome to the Sample App!" }
        before { click_button submit }
        it { should have_content(welcome_msg) }

        describe "after a refresh" do
          before { visit current_path }
          it { should_not have_content(welcome_msg) }
        end
      end
    end
  end
end
