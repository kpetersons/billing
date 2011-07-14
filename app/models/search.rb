# == Schema Information
#
# Table name: searches
#
#  id             :integer(4)      not null, primary key
#  matter_id      :integer(4)
#  search_for     :string(255)
#  no_of_objects  :integer(1)
#  express_search :boolean(1)
#  date_of_order  :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Search < ActiveRecord::Base
  belongs_to :matter

  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      unless matter.document.parent_document.nil?
        @reg_nr = "S#{id}"
        matter.document.update_attribute(:registration_number, @reg_nr)
      end
    end
  end
end
