#== Schema Information
#
# Table name: trademarks
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  appl_date          :date
#  appl_number        :string(255)
#  notes              :string(255)
#  mark_name          :string(255)
#  cfe_index          :string(255)
#  application_date   :date
#  application_number :string(255)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  reg_number         :string(255)
#

class Trademark < ActiveRecord::Base

  belongs_to :matter

  validates :mark_name, :presence => true, :length => {:within => 1..250}

  validates :appl_date, :date_not_far_future => true
  validates :application_date, :date_not_far_future => true
  validates :priority_date, :date_not_far_future => true
  validates :registration_date, :date_not_far_future => true

  validates :ctm_number, :numericality => true, :allow_blank => true, :allow_nil => true
  validates :wipo_number, :numericality => true, :allow_blank => true, :allow_nil => true
  validates :reg_number, :numericality => true, :allow_blank => true, :allow_nil => true

  before_save :replace_spaces
  before_update :replace_spaces

  attr_protected :classes

  def replace_spaces
    ctm_number.gsub!(/ /, "") unless ctm_number.nil?
    reg_number.gsub!(/ /, "") unless reg_number.nil?
    wipo_number.gsub!(/ /, "") unless wipo_number.nil?
  end

  validate :unique_per_matter

  def unique_per_matter
    m_doc = self.matter
    unless m_doc
      ObjectSpace.each_object(Matter) { |o| m_doc = o if o.trademark == self }
    end
    parent = m_doc.parent_matter
    [:ctm_number, :wipo_number, :reg_number].each do |attribute|
      unless self.try(attribute).eql? ""


        obj = self.class.where("#{attribute} = ?", self.try(attribute)).all.each do |obj|
          break if (persisted? && obj.id == self.id)
          break if (!parent.nil? && parent.id == obj.matter.id)

          if !parent.nil? && parent.trademark.nil?
            self.errors.add attribute, "You are trying to create sub Trademark from invalid parent matter!" and break
          end
          unless obj.nil?
            self.errors.add attribute, "is not unique!"
          end
        end
      end
    end
  end
end


# == Schema Information
#
# Table name: trademarks
#
#  id                 :integer         not null, primary key
#  appl_date          :date
#  appl_number        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  mark_name          :string(255)
#  cfe_index          :string(255)
#  application_date   :date
#  application_number :string(255)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  reg_number         :string(255)
#  registration_date  :date
#  renewal_date       :date
#  non_lv_reg_nr      :string(255)
#  publication_date   :date
#

