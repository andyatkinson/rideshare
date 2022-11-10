class User < ApplicationRecord
  has_secure_password
  validates :first_name, :last_name, presence: true

  validates :email,
    presence: true,
    uniqueness: true,
    email: true # custom validator

  validates :password,
    length: { minimum: 6 },
    confirmation: true, # automatically added by has_secure_password, prob. redundant
    if: -> { new_record? || !password.nil? }

  # NOTE on password confirmation:
  # Validation only called when password_confirmation attribute is present

  def display_name
    "#{first_name.capitalize} #{last_name[0].capitalize}."
  end

end
