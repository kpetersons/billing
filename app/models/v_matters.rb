# == Schema Information
#
# Table name: v_matters
#
#  id                    :integer         primary key
#  author_id             :integer
#  parent_id             :integer
#  registration_number   :string(255)
#  description           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  notes                 :string(255)
#  applicant             :string(255)
#  agent                 :string(255)
#  author                :text
#  operating_party       :string(255)
#  type                  :string(255)
#  status                :string(255)
#  wipo_number           :string(255)
#  priority_date         :date
#  mark_name             :string(255)
#  ctm_number            :string(255)
#  cfe_index             :string(255)
#  application_number    :string(255)
#  application_date      :date
#  patent_number         :string(255)
#  patent_grant_date     :date
#  ep_appl_number        :string(255)
#  ep_number             :integer
#  design_number         :string(255)
#  rdc_appl_number       :string(255)
#  rdc_number            :string(255)
#  opposed_marks         :string(255)
#  instance              :string(255)
#  date_of_closure       :date
#  opposite_party        :string(255)
#  opposite_party_agent  :string(255)
#  legal_type            :string(255)
#  date_of_order_alert   :date
#  ca_application_date   :date
#  ca_application_number :string(255)
#  client_all_ip         :string(255)
#  patent_eq_numbers     :string(255)
#  no_of_patents         :integer(2)
#  date_of_order         :date
#  search_for            :string(255)
#  no_of_objects         :integer(2)
#  express_search        :boolean
#  domain_name           :string(255)
#  registration_date     :date
#

class VMatters < ActiveRecord::Base

  has_many :matter_tasks, :foreign_key => :matter_id

  def self.quick_search query, page
    paginate :per_page => 10, :page => page, :conditions => ['registration_number like :q or description like :q or notes like :q or applicant like :q or agent like :q or author like :q or operating_party like :q or matter_type like :q or matter_status like :q or wipo_number like :q or mark_name like :q or ctm_number like :q or cfe_index like :q or application_number like :q or patent_number like :q or ep_appl_number like :q or design_number like :q or rdc_appl_number like :q or rdc_number like :q or opposed_marks like :q or instance like :q or opposite_party like :q or opposite_party_agent like :q or legal_type like :q or ca_application_number like :q or client_all_ip like :q or patent_eq_numbers like :q', {:q => "%#{query}%", :gi => query}]
  end

end
