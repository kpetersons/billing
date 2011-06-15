# == Schema Information
# Schema version: 20110609074500
#
# Table name: genders
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Gender < ActiveRecord::Base
end
