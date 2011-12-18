class ApplicationController < ActionController::Base

  def update_activity_time
    session[:expires_at] = 30.minutes.from_now
  end

  protect_from_forgery
  include SessionsHelper

  before_filter :authenticate, :update_activity_time

  def per_page
    @per_page ||= 5
  end

  def split_to_arry value
    result = Array.new
    "#{value[:value]}".capitalize.split(";").each do |val|
      if val.include? ".."
        left, right = nil
        val.split("..").each do |val_sub|
          if left.nil?
            left = val_sub.gsub(/[a-zA-Z]/, "")
          else
            right = val_sub.gsub(/[a-zA-Z]/, "")
          end
        end
        puts "left and right: #{left}, #{right}"
        for i in left.to_i..right.to_i
          puts "in loop #{i}"
          result<<i
        end
      else
        result<<val
      end
    end
    return result
  end

  def check_date
    test = params[:test]
    begin
      @date = Date.strptime(test, '%d.%m.%Y')
      render :text => @date.to_datetime().strftime('%d-%b-%Y')
    rescue
      render :text => "#{test} is invalid date"
    end
  end
end
