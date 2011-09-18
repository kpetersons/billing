# == Schema Information
#
# Table name: user_filter_columns
#
#  id              :integer(4)      not null, primary key
#  user_filter_id  :integer(4)
#  column_name     :string(255)
#  column_type     :string(255)
#  column_query    :string(255)
#  column_position :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe UserFilterColumn do
  pending "add some examples to (or delete) #{__FILE__}"
end
