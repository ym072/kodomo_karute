class CreateReportedSymptoms < ActiveRecord::Migration[7.2]
  def change
    create_table :reported_symptoms, id: :uuid do |t|
      t.references :disease_record, null: false, foreign_key: true, type: :uuid
      t.references :symptom_name, null: false, foreign_key: true
      t.datetime :recorded_at
      t.text :memo
      t.float :body_temperature
      t.timestamps
    end
  end
end
