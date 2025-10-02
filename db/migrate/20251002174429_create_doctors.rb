class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :last_name
      t.string :zip_code
      t.integer :city_id
      t.integer :specialty_id

      t.timestamps
    end
  end
end
