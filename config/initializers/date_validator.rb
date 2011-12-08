class DateNotFarFutureValidator<ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    if value.nil?
      return
    end
    begin
      year = value.strftime("%Y")
      if year.to_i > 10000
        record.errors[attribute]<<(options[:message] || "is too far in future.")
      end
    rescue => e
      record.errors[attribute]<<(options[:message] || "is not an date.")
    end
  end
end