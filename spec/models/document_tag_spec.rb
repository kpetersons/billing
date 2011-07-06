# == Schema Information
#
# Table name: document_tags
#
#  id          :integer(4)      not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  document_id :integer(4)
#  tag_id      :integer(4)
#

require 'spec_helper'

describe DocumentTag do
  pending "add some examples to (or delete) #{__FILE__}"
end
