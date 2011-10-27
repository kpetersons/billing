# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
end
