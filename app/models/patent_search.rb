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

  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "PS#{id}#{Time.new.strftime('%y')}")
    end
  end
end
