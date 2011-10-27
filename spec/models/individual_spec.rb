# == Schema Information
#
# Table name: individuals
#
#  id          :integer         not null, primary key
#  party_id    :integer
#  gender_id   :integer
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  birth_date  :date
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Individual do
  pending "add some examples to (or delete) #{__FILE__}"
end
