# == Schema Information
#
# Table name: user_filter_columns
#
#  id              :integer         not null, primary key
#  user_filter_id  :integer
#  column_name     :string(255)
#  column_type     :string(255)
#  column_query    :string(255)
#  column_position :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class UserFilterColumn < ActiveRecord::Base
  belongs_to :user_filter
end
