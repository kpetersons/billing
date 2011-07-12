# == Schema Information
#
# Table name: matter_images
#
#  id                 :integer(4)      not null, primary key
#  matter_id          :integer(4)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class MatterImage < ActiveRecord::Base
  
  belongs_to :matter
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    
end
