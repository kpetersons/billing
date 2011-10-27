# == Schema Information
#
# Table name: patent_searches
#
#  id                :integer         not null, primary key
#  matter_id         :integer
#  description       :string(255)
#  patent_eq_numbers :string(255)
#  no_of_patents     :integer(2)
#  date_of_order     :date
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe PatentSearch do
  pending "add some examples to (or delete) #{__FILE__}"
end
