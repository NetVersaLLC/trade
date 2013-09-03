module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def breadcrumb_for_location(location)
    @breadcrumb = generate_breadcrumb([], location)
    render 'directory/breadcrumb'
  end

  def generate_breadcrumb(elements, location)
    elements.unshift(location)
    if location.parent_location_id == 0
      return elements
    end
    parent = Location.find(location.parent_location_id)
    generate_breadcrumb(elements, parent)
  end

end
