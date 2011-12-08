# == Schema Information
#
# Table name: searches
#
#  id             :integer         not null, primary key
#  matter_id      :integer
#  search_for     :string(255)
#  no_of_objects  :integer(2)
#  express_search :boolean
#  date_of_order  :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Search < ActiveRecord::Base
  belongs_to :matter
  
  validates :search_for, :presence => true
  validates :date_of_order, :presence => true
  validates :no_of_objects, :presence => true
  validates :date_of_order, :date_not_far_future => true

  attr_protected :classes

end
