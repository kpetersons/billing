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

class UserPreferences < ActiveRecord::Base

  attr_accessible :user_id, :rows_per_page

  belongs_to :user

  validates :rows_per_page, :numericality => {:only_integer => true, :greater_than => 10, :less_than => 501}

  def safe_rows_per_page
    rows_per_page || 20
  end

end
