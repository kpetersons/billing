# == Schema Information
#
# Table name: relationship_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  built_in   :boolean
#  created_at :datetime
#  updated_at :datetime
#

class RelationshipType < ActiveRecord::Base

  has_one :relationship, :foreign_key => :relationship_type_id, :autosave => true

  validates :name, :presence => true
end
