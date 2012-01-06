module MattersHelper

  def can_edit? matter, status
    if has_function(:name => "funct.#{status}") && !matter.status_name.eql?("matters.status.canceled")
      return true
    end
    return !matter.status_name.eql?("matters.status.canceled") || (matter.status_name.eql?("matters.status.canceled") && has_function(:name =>"funct.matters.status.override"))
  end

  def can_change_state? matter, status
    can_edit? matter, status
  end

end
