class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.integer :doctor_id
      t.integer :patient_id
      t.integer :city_id
      t.datetime :date

      t.timestamps
    end
  end
end
