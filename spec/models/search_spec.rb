# == Schema Information
#
# Table name: searches
#
#  id             :integer         not null, primary key
#  matter_id      :integer
#  search_for     :string(255)
#  no_of_objects  :integer(2)
#  express_search :boolean
#  date_of_order  :date
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Search do
  pending "add some examples to (or delete) #{__FILE__}"
end
