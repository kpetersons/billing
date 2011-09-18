# == Schema Information
#
# Table name: default_filter_columns
#
#  id              :integer(4)      not null, primary key
#  column_name     :string(255)
#  column_type     :string(255)
#  column_query    :string(255)
#  column_position :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class DefaultFilterColumn < ActiveRecord::Base
  
    validates :column_name, :presence => true, 
              :uniqueness       => {:case_sensitive => false},
end
