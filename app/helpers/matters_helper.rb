module MattersHelper

  def can_edit matter
    return !matter.status_name.eql?("matters.status.canceled") || (matter.status_name.eql?("matters.status.canceled") && has_function(:name =>"funct.matters.status.override"))
  end

end
