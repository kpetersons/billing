# == Schema Information
#
# Table name: relationships
#
#  id                   :integer         not null, primary key
#  source_party_id      :integer
#  target_party_id      :integer
#  relationship_type_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class Relationship < ActiveRecord::Base

  belongs_to  :relationship_type
  belongs_to  :source_party, :class_name => 'Party', :foreign_key => :source_party_id
  belongs_to  :target_party, :class_name => 'Party', :foreign_key => :target_party_id

  attr_accessible :relationship_type_id, :source_party_id, :target_party_id

  validates :relationship_type_id,  :presence => true
  validates :source_party_id,       :presence => true
  validates :target_party_id,       :presence => true
end
