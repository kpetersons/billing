class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :authenticate
  def per_page
    @per_page ||= 5
  end

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
