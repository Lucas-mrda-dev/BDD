# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
require "faker"

Faker::Config.locale = "fr"

puts " Cleaning DB..."
Appointment.destroy_all
Specialty.destroy_all
Doctor.destroy_all
Patient.destroy_all
City.destroy_all

puts " Creating cities..."
cities = 10.times.map do
  City.create!(
    city_name: Faker::Address.unique.city
  )
end
Faker::UniqueGenerator.clear

puts " Creating specialties..."
specialty_names = [
  "Cardiologie", "Dermatologie", "Médecine générale", "Pédiatrie", "Neurologie",
  "Gynécologie", "Psychiatrie", "Ophtalmologie", "Orthopédie", "ORL"
]
specialties = specialty_names.map do |name|
  Specialty.create!(name_specialty: name)
end

puts " Creating doctors..."
doctors = 25.times.map do
  Doctor.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    zip_code:   Faker::Address.zip_code,
    city:       cities.sample,
    specialty:  specialties.sample # => remplit specialty_id
  )
end

puts " Creating patients..."
patients = 25.times.map do
  Patient.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    city:       cities.sample
  )
end

puts " Linking specialties to a doctor (specialties.doctor_id)..."
specialties.each do |s|
  doc = doctors.select { |d| d.specialty_id == s.id }.sample
  # S’il n’y en a pas (peu probable), on force un docteur à avoir cette spécialité
  if doc.nil?
    doc = doctors.sample
    doc.update!(specialty: s)
  end
  s.update!(doctor_id: doc.id)
end

puts " Creating appointments..."
50.times do
  patient = patients.sample
  # on préfère un docteur de la même ville que le patient
  candidates = doctors.select { |d| d.city_id == patient.city_id }
  doctor = (candidates.any? ? candidates : doctors).sample

  Appointment.create!(
    doctor: doctor,
    patient: patient,
    city: doctor.city, # cohérent avec la ville du docteur
    date: Faker::Time.between(from: 1.month.ago, to: 1.month.from_now)
  )
end

puts "✅ Done!"
puts "Cities: #{City.count} | Doctors: #{Doctor.count} | Patients: #{Patient.count} | Specialties: #{Specialty.count} | Appointments: #{Appointment.count}"
