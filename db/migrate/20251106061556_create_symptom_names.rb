class CreateSymptomNames < ActiveRecord::Migration[7.2]
  def change
    create_table :symptom_names do |t|
      t.string :name
      t.timestamps
    end
  end
end
