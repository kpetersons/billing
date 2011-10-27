# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  individual_id      :integer
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  active             :boolean
#  blocked            :boolean
#  registration_date  :date
#  activation_key     :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer
#  initials           :string(255)
#  login_date         :datetime
#  last_login_date    :datetime
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
