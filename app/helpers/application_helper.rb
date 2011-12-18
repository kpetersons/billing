module ApplicationHelper

  def default_title
    "PetPat Billing App"
  end

  def col_check id, value
    check_box_tag '', '', value, :disabled => true
  end

  def current_url params = {}, data = {}
    #data = reject_object data
    data.merge(params) unless params.nil?
  end

  def search_url_query
    if @detail_search.nil?
      return ""
    end
    return "!#{@detail_search.url_query}!"
  end

  def date_format_field value
    if value.nil?
      return ""
    end
    return value.to_s(:default)
  end

  private
  def reject_object data
    clean = proc {
        |k, v|
      puts "Key #{k}"
      k.eql? "order_by" or v.instance_of?(Hash) && v.delete_if(&clean)
    }
    data.delete_if &clean
  end

end
