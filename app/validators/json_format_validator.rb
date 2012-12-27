class JsonFormatValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      JSON.parse(value) unless value.blank?
    rescue
      record.errors[attribute] << (options[:message] || 'is not a properly formatted JSON')
    end
  end
end