# == Schema Information
#
# Table name: legal_types
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#

class LegalType < ActiveRecord::Base
end
