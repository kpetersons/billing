# == Schema Information
#
# Table name: patents
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  patent_number      :string(255)
#  patent_grant_date  :date
#  ep_appl_number     :string(255)
#  ep_number          :integer
#  registration_date  :date
#

class Patent < ActiveRecord::Base

  belongs_to :matter

  validates :application_date, :date_not_far_future => :true
  validates :patent_grant_date, :date_not_far_future => :true
  validates :registration_date, :date_not_far_future => :true


  validates :patent_number, :numericality => true, :allow_blank => true, :allow_nil => true
  validates :ep_number, :numericality => true, :allow_blank => true, :allow_nil => true

  validate :unique_per_matter

  def unique_per_matter
    m_doc = self.matter
    unless m_doc
      ObjectSpace.each_object(Matter) { |o| m_doc = o if o.patent == self }
    end
    parent = m_doc.parent_matter
    [:patent_number, :ep_number].each do |attribute|
      unless self.try(attribute).eql? ""

        obj = self.class.where("#{attribute} = ?", self.try(attribute)).all.each do |obj|
          break if (persisted? && obj.id == self.id)
          break if (!parent.nil? && parent.id == obj.matter.id)

          if !parent.nil? && parent.patent.nil?
            self.errors.add attribute, "You are trying to create sub Patent from invalid parent matter!" and break
          end
          unless obj.nil?
            self.errors.add attribute, "is not unique!"
          end
        end
      end
    end
  end

end
