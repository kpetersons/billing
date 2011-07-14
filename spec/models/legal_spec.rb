# == Schema Information
#
# Table name: legals
#
#  id                   :integer(4)      not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  matter_id            :integer(4)
#  opposed_marks        :string(255)
#  type                 :integer(4)
#  instance             :string(255)
#  opposite_party       :integer(4)
#  opposite_party_agent :integer(4)
#  date_of_closure      :date
#

require 'spec_helper'

describe Legal do
  pending "add some examples to (or delete) #{__FILE__}"
end
