# == Schema Information
#
# Table name: exchange_rates
#
#  id           :integer(4)      not null, primary key
#  currency_id  :integer(4)
#  rate         :decimal(8, 3)
#  from_date    :date
#  created_at   :datetime
#  updated_at   :datetime
#  through_date :date
#

require 'spec_helper'

describe ExchangeRate do
  pending "add some examples to (or delete) #{__FILE__}"
end
