module ApplicationHelper

  def default_title
    "PetPat Billing App"
  end

  def col_check id, value
    check_box_tag '', '', value, :disabled => true
  end

  def current_url data = {}
    data = reject_object data
    data[:overwrite].merge(data[:prms])
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
    if data.empty?
      return {}
    end
    data.keys.each do |key|
      logger.error "Key #{key} Value #{data[key]}"
      if data[key].instance_of? Hash
        reject_object data[key]
      end
    end
    return data
  end

end
