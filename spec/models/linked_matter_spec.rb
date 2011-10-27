# == Schema Information
#
# Table name: linked_matters
#
#  id               :integer         not null, primary key
#  matter_id        :integer
#  linked_matter_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe LinkedMatter do
  pending "add some examples to (or delete) #{__FILE__}"
end
