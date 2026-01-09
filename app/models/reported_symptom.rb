class ReportedSymptom < ApplicationRecord
  belongs_to :disease_record
  belongs_to :symptom_name, optional: true

  validates :symptom_name_id, presence: true, unless: -> { body_temperature.present? || memo.present? }
end
