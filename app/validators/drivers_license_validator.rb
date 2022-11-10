class DriversLicenseValidator < ActiveModel::EachValidator

  # https://success.myshn.net/Data_Protection/Data_Identifiers/U.S._Driver%27s_License_Numbers
  # valid example: P800000224322
  DL_MN_REGEXP_FORMAT = /[a-zA-Z]\d{12}/i

  def validate_each(record, attribute, value)
    unless value =~ DL_MN_REGEXP_FORMAT
      record.errors.add(attribute, (options[:message] || "is not a valid driver's license number"))
    end
  end
end
