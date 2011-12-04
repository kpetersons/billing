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
Date::DATE_FORMATS[:show_invoice] = "%d-%b-%Y"
Date::DATE_FORMATS[:check] = "%d.%b.%Y"
Time::DATE_FORMATS[:default] = "%d.%m.%Y"
Time::DATE_FORMATS[:show] = "%d.%b.%Y"
Time::DATE_FORMATS[:show_full] = "%d.%b.%Y %H:%M"
Time::DATE_FORMATS[:check] = "%d.%b.%Y"
Time::DATE_FORMATS[:yr] = "%y"

Mime::Type.register "application/pdf", :pdf 