# == Schema Information
#
# Table name: domains
#
#  id                :integer         not null, primary key
#  matter_id         :integer
#  domain_name       :string(255)
#  registration_date :date
#  created_at        :datetime
#  updated_at        :datetime
#

class Domain < ActiveRecord::Base
  belongs_to :matter

  validates :registration_date, :date_not_far_future => true

end
