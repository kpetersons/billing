# == Schema Information
#
# Table name: matter_statuses
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  revert_to_name :string(255)
#  pass_to_name   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class MatterStatus < ActiveRecord::Base
end
