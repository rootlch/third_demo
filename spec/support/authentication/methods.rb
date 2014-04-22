include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def invalid_signin
  click_button "Sign in"
end

def have_error_msg
  have_selector("div.alert.alert-error")
end
