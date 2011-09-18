# == Schema Information
#
# Table name: default_filters
#
#  id         :integer(4)      not null, primary key
#  table_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DefaultFilter < ActiveRecord::Base
end
