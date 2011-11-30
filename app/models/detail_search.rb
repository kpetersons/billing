class DetailSearch

  attr_accessor :details

  def initialize params
    @all_fields = params[:columns]
    @all_fields_hash = fields_to_hash @all_fields
    params[:details].keys.each do |detail|
      add_detail params[:details][detail]
    end unless params[:details].nil?
    if params[:details].nil? || params[:details].empty?
      add_detail Hash.new
    end
  end

  def add_detail detail
    if @details.nil?
      @details = Array.new
    end
    @details << detail
  end

  def details
    return @details || Array.new
  end

  def all_fields
    @all_fields
  end

  def all_conjunctions
    return [
        "",
        "AND",
        "OR",
        "AND NOT",
        "OR NOT",
    ]
  end

  def query
    query_s = ""
    @details.each do |item|
      query_s = "#{query_s} #{item[:conjunction]} #{item[:opening_bracket]} #{query_field_comparator item} #{item[:closing_bracket]}"
    end
    return query_s
  end

  private

  def fields_to_hash fields
    data = {}
    fields.each do |field|
      data[field.column_query] = {:data_type => field.column_type}
    end
    return data
  end

  def query_field_comparator item
    comparator = "#{item[:field]} "
    if @all_fields_hash[item[:field]][:data_type].eql?("col-date")
      comparator = "#{comparator} between #{upper item, item[:range_from]}..#{upper item, item[:range_to]} "
    else
      regular = "'%#{item[:regular]}%'"
      comparator = "#{comparator} #{get_conjunction item, @all_fields_hash[item[:field]][:data_type]} #{upper item, regular}"
    end
    return comparator
  end

  def get_conjunction item, type
    if type.eql? "col-text"
      return " like "
    else
      return " = "
    end
  end

  def upper item, val
    if item[:match_case].eql? "1"
      return val = "upper(#{val})"
    end
    return val
  end

end

class Detail

  def initialize params
    @conjunction = params[:conjunction]
    @opening_bracket = params[:opening_bracket]
    @closing_bracket = params[:closing_bracket]
    @field = params[:field]
    @range_from = params[:range_from]
    @range_to = params[:range_to]
    @regular = params[:regular]
    @match_case = params[:match_case]
  end

  attr_accessor :conjunction, :opening_bracket, :closing_bracket, :field, :range_from, :range_to, :regular, :match_case
end