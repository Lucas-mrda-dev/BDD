class Patient < ApplicationRecord
  has_many :doctors
  has_many :appointments
  belongs_to :city
end
