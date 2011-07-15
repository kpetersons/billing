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

class PatentSearch < ActiveRecord::Base
  belongs_to :matter

  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.registration_number = "PS#{id}#{Time.new.strftime('%y')}"
    end
  end
end
