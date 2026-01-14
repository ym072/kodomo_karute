require "rails_helper"

RSpec.describe "DiseaseRecords", type: :request do

  it "createできる" do
    user = create_user!(email: "dr_create@example.com")
    sign_in user
    kid = create_kid!(user: user)

    expect do
      post kid_disease_records_path(kid), params: {
        disease_record: { name: "風邪", start_at: Time.current }
      }
    end.to change(DiseaseRecord, :count).by(1)

    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(kid_path(kid))
  end

  it "indexが表示できる（終了済みレコードがある状態）" do
    user = create_user!(email: "dr_index@example.com")
    sign_in user
    kid = create_kid!(user: user)
    create_disease_record!(kid: kid, start_at: 2.days.ago, end_at: 1.day.ago)

    get kid_disease_records_path(kid)
    expect(response).to have_http_status(:ok)
  end
end
