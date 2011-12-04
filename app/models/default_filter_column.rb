# == Schema Information
#
# Table name: default_filter_columns
#
#  id                 :integer         not null, primary key
#  column_name        :string(255)
#  column_type        :string(255)
#  column_query       :string(255)
#  column_position    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  default_filter_id  :integer
#  is_default         :boolean
#  column_order_query :string(255)
#  translate          :boolean         default(FALSE)
#

class DefaultFilterColumn < ActiveRecord::Base
  
    validates :column_name, :presence => true, 
              :uniqueness       => {:case_sensitive => false, :scope => :default_filter_id}
end
