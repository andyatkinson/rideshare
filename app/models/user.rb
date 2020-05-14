class User < ApplicationRecord
  validates :first_name, :last_name, presence: true

  validates :email,
    presence: true,
    uniqueness: true,
    email: true # custom validator

  def display_name
    "#{first_name.capitalize} #{last_name[0].capitalize}."
  end
end
