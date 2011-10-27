# == Schema Information
#
# Table name: default_filters
#
#  id         :integer         not null, primary key
#  table_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DefaultFilter < ActiveRecord::Base
    validates :table_name, :presence => true,
              :uniqueness       => {:case_sensitive => false},
end
