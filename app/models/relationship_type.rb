# == Schema Information
# Schema version: 20110609074500
#
# Table name: relationship_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  built_in   :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class RelationshipType < ActiveRecord::Base

  has_one :relationship, :foreign_key => :relationship_type_id, :autosave => true

  validates :name, :presence => true
end
