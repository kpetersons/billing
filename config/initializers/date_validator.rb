class DateNotFarFutureValidator<ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    if value.nil?
      return
    end
    begin
      year = value.strftime("%Y")
      if year.to_i > 2200
        record.errors[attribute]<<(options[:message] || "is too far in future.")
      end
      if year.to_i < 1900
        record.errors[attribute]<<(options[:message] || "is too far in past.")
      end
    rescue => e
      record.errors[attribute]<<(options[:message] || "is not an date.")
    end
  end
end