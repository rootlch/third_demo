module ApplicationHelper
  def full_title(title)
    base_title = "Ruby on Rails Tutorial Sample App"
    unless title.empty?
      "#{base_title} | #{title}"
    else
      base_title
    end
  end

  def user_name
    signed_in? ? " | #{current_user.name}" : ""
  end
end
