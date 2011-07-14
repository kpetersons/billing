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
