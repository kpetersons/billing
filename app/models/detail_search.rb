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

  def url_query
    return {
        :detail_search => {
            :details => @details
        }
    }
  end

  def add_detail detail
    if @details.nil?
      @details = Array.new
    end
    @details << Detail.new(detail)
  end

  def details
    return @details || Array.new
  end

  def all_fields
    @all_fields
  end

  def all_fields_hash
    @all_fields_hash
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
      query_s = "#{query_s} #{item.conjunction} #{item.opening_bracket} #{query_field_comparator item} #{item.closing_bracket}"
    end
    puts "QUERY: #{query_s}"
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
    comparator = ""
    if @all_fields_hash[item.field][:data_type].eql?("col-date")
      comparator = item.field
      comparator = "#{comparator} between date '#{Date.strptime(item.range_from, '%d.%m.%Y').yesterday.to_s(:db)}' and date '#{Date.strptime(item.range_to, '%d.%m.%Y').tomorrow.to_s(:db)}' "
    else
      regular = item.regular
      type = @all_fields_hash[item.field][:data_type]
      if type.eql?("col-text") && item.precision.eql?("Contains")
        regular = upper item, "'%#{regular}%'"
        regular = "ilike #{regular}"
      else
        if @all_fields_hash[item.field][:data_type].eql?("col-text")
          regular = upper item, "'#{regular}'"
        end
        regular = " = #{regular}"
      end
      comparator = "#{comparator} #{upper(item, item.field)} #{regular}"
    end
    return comparator
  end

  def upper item, val
    if item.match_case.eql? "0" && @all_fields_hash[item.field][:data_type].eql?("col-text")
      return "upper(#{val})"
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
    @precision = params[:precision]
  end

  attr_accessor :conjunction, :opening_bracket, :closing_bracket, :field, :range_from, :range_to, :regular, :match_case, :precision

end