class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :authenticate
  
  def per_page
    @per_page ||= 5
  end
   
end
