# == Schema Information
#
# Table name: default_filter_columns
#
#  id                :integer(4)      not null, primary key
#  column_name       :string(255)
#  column_type       :string(255)
#  column_query      :string(255)
#  column_position   :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  default_filter_id :integer(4)
#  is_default        :boolean(1)
#

require 'spec_helper'

describe DefaultFilterColumn do
  pending "add some examples to (or delete) #{__FILE__}"
end
