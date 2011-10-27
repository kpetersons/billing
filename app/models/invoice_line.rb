# == Schema Information
#
# Table name: invoice_lines
#
#  id                   :integer         not null, primary key
#  invoice_id           :integer
#  official_fee_type_id :integer
#  details              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  attorney_fee_type_id :integer
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  author_id            :integer
#  offering             :string(255)
#  items                :integer
#  units                :string(255)
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to  :author, :class_name => "User", :foreign_key => :author_id
  
  validates :attorney_fee_type_id, :presence => true, :if => Proc.new {|invoice_line| !invoice_line.attorney_fee.nil?}
  validates :official_fee_type_id, :presence => true, :if => Proc.new {|invoice_line| !invoice_line.official_fee.nil?}
  validates :offering, :presence => true, :length              => {:within => 5..250}
  validates :items, :presence => true, :numericality => true
  
  def fee_without_vat
    fee_without_vat = 0;
    fee_without_vat += official_fee unless official_fee.nil? 
    fee_without_vat += attorney_fee unless attorney_fee.nil?
  end

  def is_official
    if official_fee_type_id
      return true
    end
    return false
  end

  def provided_fee_description
     return "#{details}"
  end
  
  def provided_fee_details
    if is_official
      return offering
    end
    return "#{offering}, #{details}"
  end
  
  def provided_fee_amount
    if is_official
      return official_fee
    end
    return attorney_fee
  end

  def provided_fee_without_vat
    if is_official
      return official_fee * items
    end
    return attorney_fee * items  
  end
  
  def line_total
    total_a = 0
    total_a = total_a + items unless items.nil?
    total_a = total_a * official_fee unless official_fee.nil?
    
    total_b = 0
    total_b = total_b + items unless items.nil?
    total_b = total_b * attorney_fee unless attorney_fee.nil?
    
    return total_a + total_b unless total_b.nil? && total_a.nil?
    return total_a unless total_a.nil?
    return total_b unless total_b.nil?
    return 0
  end
  
  def official_fee_total
    total = 0
    total = total + items unless items.nil?
    total = total * official_fee unless official_fee.nil?
    return total
  end
  
  def attorney_fee_total
    total = 0
    total = total + items unless items.nil?
    total = total * attorney_fee unless attorney_fee.nil?
    return total
  end  
end
