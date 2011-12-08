# == Schema Information
#
# Table name: contacts
#
#  id              :integer         not null, primary key
#  party_id        :integer
#  contact_type_id :integer
#  contact_value   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Contact < ActiveRecord::Base
  
  belongs_to :contact_type
  belongs_to :party
  
  validates :contact_value, :presence => true
  before_validation :original_no_longer_used

  def no_longer_used
    #update_attribute(:date_effective_end, DateTime.current)
  end

  private
  def original_no_longer_used
    #originals = Contact.find_all_by_orig_id orig_id
    #originals.each do |original|
    #  original.no_longer_used unless original.id == self.id
    #end
  end
end
