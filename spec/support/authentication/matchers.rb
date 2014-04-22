include ApplicationHelper

RSpec::Matchers.define :have_signed_in do |user|
  match do |page|
    expect(page).to have_title(user.name)
    expect(page).to have_link("Profile", href: user_path(user))
    expect(page).to have_link("Sign out", href: signout_path)
    expect(page).to_not have_link("Sign in", href: signin_path)
  end
end

Rspec::Matchers.define :not_signed_in do
  match do |page|
    expect(page).to have_content("Sign in")
    expect(page).to have_title("Sign in")
  end
end
