class Kid < ApplicationRecord
  belongs_to :user

  has_one_attached :icon

  validates :name, presence: true, length: { maximum: 50 }

  validates :birthday, presence: true

  has_many :disease_records, dependent: :destroy

  def icon_validation
    return unless icon.attached?
  
    acceptable_types = ["image/jpeg", "image/png", "image/webp", "image/gif"]
    unless acceptable_types.include?(icon.blob.content_type)
      errors.add(:icon, "はJPEG/PNG/WebP/GIFのみ対応です（HEICは未対応）")
    end
  
    if icon.blob.byte_size > 3.megabytes
      errors.add(:icon, "は3MB以内にしてください")
    end
  end
end
