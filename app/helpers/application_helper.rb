module ApplicationHelper

  def default_title
    "PetPat Billing App"
  end

  def col_check id, value
    check_box_tag '', '', value, :disabled => true
  end
  
end
