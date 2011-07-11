class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :authenticate
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

end
