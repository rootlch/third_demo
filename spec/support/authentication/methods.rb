include ApplicationHelper

def valid_signin(user, options = {})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    fill_in "Email", with: user.email.upcase
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def invalid_signin
  click_button "Sign in"
end

def have_error_msg
  have_selector("div.alert.alert-error")
end
