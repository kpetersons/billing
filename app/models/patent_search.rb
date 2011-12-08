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

class PatentSearch < ActiveRecord::Base
  belongs_to :matter

  validates :date_of_order, :presence => true
  validates :date_of_order, :date_not_far_future => true

end
