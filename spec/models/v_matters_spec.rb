require 'spec_helper'

describe VMatters do
  pending "add some examples to (or delete) #{__FILE__}"
end


# == Schema Information
#
# Table name: v_matters
#
#  image_exists            :text
#  matter_type_id          :integer
#  operating_party_id      :integer
#  agent_id                :integer
#  applicant_id            :integer
#  id                      :integer         primary key
#  author_id               :integer
#  parent_id               :integer
#  registration_number     :text
#  description             :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  notes                   :string(255)
#  applicant               :string(255)
#  agent                   :string(255)
#  author                  :text
#  operating_party         :string(255)
#  matter_type             :string(255)
#  matter_status           :string(255)
#  classes                 :text
#  wipo_number             :string(255)
#  priority_date           :date
#  mark_name               :string(255)
#  ctm_number              :string(255)
#  cfe_index               :string(255)
#  application_number      :string(255)
#  application_date        :date
#  patent_number           :string(255)
#  patent_grant_date       :date
#  ep_appl_number          :string(255)
#  ep_number               :integer
#  design_number           :string(255)
#  rdc_appl_number         :string(255)
#  rdc_number              :string(255)
#  opposed_marks           :string(255)
#  instance                :string(255)
#  date_of_closure         :date
#  opposite_party          :string(255)
#  opposite_party_agent    :string(255)
#  legal_type              :string(255)
#  court_ref               :text
#  vid_ref                 :text
#  date_of_order_alert     :date
#  ca_application_date     :date
#  ca_application_number   :string(255)
#  client_all_ip           :string(255)
#  patent_eq_numbers       :string(255)
#  no_of_patents           :integer(2)
#  date_of_order           :date
#  search_for              :string(255)
#  no_of_objects           :integer(2)
#  express_search          :boolean
#  domain_name             :string(255)
#  registration_date       :date
#  opposite_party_id       :integer
#  opposite_party_agent_id :integer
#  tm_registration_number  :string(255)
#  renewal_date            :date
#  non_lv_reg_nr           :string(255)
#  publication_date        :date
#

