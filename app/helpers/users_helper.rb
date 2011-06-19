module UsersHelper
  
  def has_function name    
    current_user.has_function(name)
  end
  
  def escape_a_item name
    content_tag(:span, name, :class => 'a')
  end
    
end
