class Doctor < ApplicationRecord
  has_many :patients
  has_many :appointments
  belongs_to :specialty
  belongs_to :city
end
