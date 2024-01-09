class User < ApplicationRecord
  has_secure_password
  validates :first_name, :last_name, presence: true
  validates :drivers_license_number,
    length: { maximum: 100 }

  include PgSearch::Model

  # searchable_full_name column combines
  # first_name and last_name
  # Each receives a weight, in the stored generated column
  # definition
  pg_search_scope :search_by_full_name,
    against: {
      first_name: 'A', # highest weight
      last_name: 'B'
    }
    # Swap the config above for the one on the next line,
    # after adding the column `searchable_full_name`
    # against: :searchable_full_name, # stored generated column tsvector
    # using: {
    #   tsearch: { 
    #     dictionary: 'english',
    #     tsvector_column: 'searchable_full_name'
    #   }
    # }

  pg_search_scope :unaccent_search,
    against: [:first_name, :last_name],
    ignoring: :accents

  validates :email,
    presence: true,
    uniqueness: true,
    email: true # custom validator

  validates :password,
    length: { minimum: 6 },
    confirmation: true, # automatically added by has_secure_password, prob. redundant
    if: -> { new_record? || !password.nil? }

  validates :type,
    presence: true

  # NOTE on password confirmation:
  # Validation only called when password_confirmation attribute is present

  def display_name
    "#{first_name.capitalize} #{last_name[0].capitalize}."
  end

end
