# == Schema Information
#
# Table name: operating_party_users
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  operating_party_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class OperatingPartyUser < ActiveRecord::Base
end
