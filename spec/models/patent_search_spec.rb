# == Schema Information
#
# Table name: patent_searches
#
#  id                :integer(4)      not null, primary key
#  matter_id         :integer(4)
#  description       :string(255)
#  patent_eq_numbers :string(255)
#  no_of_patents     :integer(1)
#  date_of_order     :date
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe PatentSearch do
  pending "add some examples to (or delete) #{__FILE__}"
end
