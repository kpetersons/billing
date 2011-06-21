module UsersHelper
  def has_function name
    current_user.has_function(name)
  end

  def escape_a_item name
    content_tag(:span, name, :class => 'a')
  end

  def link_to_if_function url, display, name
    link_to_if has_function(:name => name), t( display), url do
      escape_a_item(t(display))
    end
  end

end 
