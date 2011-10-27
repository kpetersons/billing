# == Schema Information
#
# Table name: relationships
#
#  id                   :integer         not null, primary key
#  source_party_id      :integer
#  target_party_id      :integer
#  relationship_type_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Relationship do
  pending "add some examples to (or delete) #{__FILE__}"
end
