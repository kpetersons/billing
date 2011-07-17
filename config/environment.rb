# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Billing::Application.initialize!
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  "<span class='error'>#{html_tag}</span>".html_safe
end

class ActiveRecord::Base
  def self.per_page
    10
  end
end

Date::DATE_FORMATS[:default] = "%d.%m.%Y"
Date::DATE_FORMATS[:show] = "%d.%b.%Y"
Date::DATE_FORMATS[:check] = "%d.%b.%Y"