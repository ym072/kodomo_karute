class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }

  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  has_many :kids, dependent: :destroy

  validate :password_must_be_different_from_current,
           if: -> { password.present? && persisted? && will_save_change_to_encrypted_password? }

  private

  def password_must_be_different_from_current
    previous_encrypted = encrypted_password_was

    return if previous_encrypted.blank?

    if Devise::Encryptor.compare(self.class, previous_encrypted, password)
      errors.add(:password, :same_as_current)
    end
  end
end
