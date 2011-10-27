# == Schema Information
#
# Table name: matter_images
#
#  id                 :integer         not null, primary key
#  matter_id          :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe MatterImage do
  pending "add some examples to (or delete) #{__FILE__}"
end
