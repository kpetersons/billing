# == Schema Information
#
# Table name: user_preferences
#
#  id            :integer         not null, primary key
#  rows_per_page :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe UserPreferences do
  pending "add some examples to (or delete) #{__FILE__}"
end
