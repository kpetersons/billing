# == Schema Information
#
# Table name: v_matters
#
#  operating_party_id    :integer
#  agent_id              :integer
#  applicant_id          :integer
#  id                    :integer         primary key
#  author_id             :integer
#  parent_id             :integer
#  registration_number   :text
#  description           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  notes                 :string(255)
#  applicant             :string(255)
#  agent                 :string(255)
#  author                :text
#  operating_party       :string(255)
#  matter_type           :string(255)
#  matter_status         :string(255)
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
    paginate :per_page => 10, :page => page, :conditions => ['registration_number ilike :q or description ilike :q or notes ilike :q or applicant ilike :q or agent ilike :q or author ilike :q or operating_party ilike :q or matter_type ilike :q or matter_status ilike :q or wipo_number ilike :q or mark_name ilike :q or ctm_number ilike :q or cfe_index ilike :q or application_number ilike :q or patent_number ilike :q or ep_appl_number ilike :q or design_number ilike :q or rdc_appl_number ilike :q or rdc_number ilike :q or opposed_marks ilike :q or instance ilike :q or opposite_party ilike :q or opposite_party_agent ilike :q or legal_type ilike :q or ca_application_number ilike :q or client_all_ip ilike :q or patent_eq_numbers ilike :q', {:q => "%#{query}%", :gi => query}]
  end

end
