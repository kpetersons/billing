class LinkedMatter < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :linked_matter, :class_name => "Matter", :foreign_key => :linked_matter_id

  attr_protected :linked_matter_registration_number  
  
end
