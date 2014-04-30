require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { should not_signed_in }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { invalid_signin }

      it { should not_signed_in }
      it { should have_error_msg }
      it { should_not have_link("Profile") }
      it { should_not have_link("Settings") }
      it { should_not have_link("Users") }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_msg }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link("Users", href: users_path) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
      it { should have_link("Sign out", href: signout_path) }
      it { should_not have_link("Sign in", href: signin_path) }
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the index page" do
          before { visit users_path }
          it { should have_title("Sign in") }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title("Sign in") }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a potected page" do
        before do
          visit edit_user_path(user)
          valid_signin(user)
        end

        describe "after signin in" do
          it { should have_title("Edit user") }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "test@test.com") }
      before { valid_signin user, no_capybara: true }

      describe "submitting a GET request" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a Patch request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin user, no_capybara: true}

      describe "visit the signin page" do
        before { get signin_path }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a Post request to the Sessions#create action" do
        before { post sessions_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { valid_signin admin, no_capybara: true }

      it "should not be able to delete self" do
        expect do
          delete user_path(admin) 
        end.to_not change{User.count}.by(-1)
      end
    end
  end

  describe "friendly redirect" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit users_path
      sign_in user
      signout
      valid_signin user
    end
    specify { expect(current_url).to eq user_url(user) }
  end
end
