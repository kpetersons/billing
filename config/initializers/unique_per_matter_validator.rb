class UniquePerMatterValidator<ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      return
    end
    begin

    rescue => e
      record.errors[attribute]<<(options[:message] || "is not valid.")
    end
  end
end