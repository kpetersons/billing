# == Schema Information
#
# Table name: default_filter_columns
#
#  id                :integer         not null, primary key
#  column_name       :string(255)
#  column_type       :string(255)
#  column_query      :string(255)
#  column_position   :integer
#  created_at        :datetime
#  updated_at        :datetime
#  default_filter_id :integer
#  is_default        :boolean
#

require 'spec_helper'

describe DefaultFilterColumn do
  pending "add some examples to (or delete) #{__FILE__}"
end
