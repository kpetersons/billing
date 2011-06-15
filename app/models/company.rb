# == Schema Information
# Schema version: 20110609074500
#
# Table name: companies
#
#  id         :integer(4)      not null, primary key
#  party_id   :integer(4)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Company < ActiveRecord::Base
    belongs_to :party, :class_name => "party", :foreign_key => "party_id"
    
    attr_accessible :party_id, :name
    
    validates :name, :presence => true
end
