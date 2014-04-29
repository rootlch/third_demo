include ApplicationHelper

Rspec::Matchers.define :not_signed_in do
  match do |page|
    expect(page).to have_content("Sign in")
    expect(page).to have_title("Sign in")
  end
end
