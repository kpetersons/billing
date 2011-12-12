# == Schema Information
#
# Table name: designs
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  design_number      :string(255)
#  rdc_appl_number    :string(255)
#  rdc_number         :string(255)
#  registration_date  :date
#

class Design < ActiveRecord::Base
  belongs_to :matter

  validates :application_date, :date_not_far_future => true
  validates :registration_date, :date_not_far_future => true

  validates :design_number, :numericality => true, :allow_nil => true, :allow_blank => true
  validates :rdc_number, :numericality => true, :allow_nil => true, :allow_blank => true

  validate :unique_per_matter

  def unique_per_matter
    m_doc = self.matter
    unless m_doc
      ObjectSpace.each_object(Matter) { |o| m_doc = o if o.design == self }
    end
    parent = m_doc.parent_matter
    [:design_number, :rdc_number].each do |attribute|
      if self.try(attribute).eql? ""
        break
      end
      obj = self.class.where("#{attribute} = ?", self.try(attribute)).all.each do |obj|
        break if (persisted? && obj.id == self.id)
        break if (!parent.nil? && parent.id == obj.matter.id)

        if !parent.nil? && parent.design.nil?
          self.errors.add attribute, "You are trying to create sub Design from invalid parent matter!" and break
        end
        unless obj.nil?
          self.errors.add attribute, "is not unique!"
        end
      end
    end
  end

end
