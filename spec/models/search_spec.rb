# == Schema Information
#
# Table name: searches
#
#  id             :integer(4)      not null, primary key
#  matter_id      :integer(4)
#  search_for     :string(255)
#  no_of_objects  :integer(1)
#  express_search :boolean(1)
#  date_of_order  :date
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Search do
  pending "add some examples to (or delete) #{__FILE__}"
end
