# == Schema Information
#
# Table name: operating_party_users
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  operating_party_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class OperatingPartyUser < ActiveRecord::Base
end
