class WebmotorsUrlValidator < ActiveModel::Validator
  def validate(record)
    return if record.source_url.blank?

    unless record.source_url.include?('webmotors.com.br')
      record.errors.add(:source_url, 'must be a valid Webmotors URL')
    end
  end
end