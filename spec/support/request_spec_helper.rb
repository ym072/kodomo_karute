module RequestSpecHelper
  def create_user!(
      name: "Test User",
      email: "test@example.com",
      password: "password"
  )
    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def create_kid!(user:, name: "Taro", birthday: Date.new(2020, 1, 1))
    Kid.create!(
      user: user,
      name: name,
      birthday: birthday
    )
  end

  def create_disease_record!(kid:, name: "風邪", start_at: Time.current, end_at: nil)
    DiseaseRecord.create!(
      kid: kid,
      name: name,
      start_at: start_at,
      end_at: end_at
    )
  end

  def create_symptom_name!(name: "咳")
    SymptomName.create!(name: name)
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end
