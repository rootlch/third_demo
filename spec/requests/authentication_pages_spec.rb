require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    it { not_signed_in }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { invalid_signin }

      it { should not_signed_in }
      it { should have_error_msg }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_msg }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      it { have_signed_in(user) }
    end
  end
end
