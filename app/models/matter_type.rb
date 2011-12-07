# == Schema Information
#
# Table name: matter_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer
#

class MatterType < ActiveRecord::Base
  
  belongs_to :function
  has_many :matters
  has_many :operating_party_matter_types
  has_many :operating_parties, :through => :operating_party_matter_types

  def translated_name
    I18n.translate(name)
  end

  def self.all_inclusive
    MatterType.all<<MatterType.new(:name => "matters.all", :id => -1)
  end

end
