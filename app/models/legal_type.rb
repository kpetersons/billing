# == Schema Information
#
# Table name: legal_types
#
#  id          :integer         not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  description :string(255)
#

class LegalType < ActiveRecord::Base
end
