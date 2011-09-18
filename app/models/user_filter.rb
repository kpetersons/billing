# == Schema Information
#
# Table name: user_filters
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  table_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UserFilter < ActiveRecord::Base
end
