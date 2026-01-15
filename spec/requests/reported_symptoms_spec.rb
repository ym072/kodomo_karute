require "rails_helper"

RSpec.describe "ReportedSymptoms", type: :request do
  it "newが表示できる（記録開始前でもOK）" do
    user = create_user!(email: "rs_new@example.com")
    sign_in user
    kid = create_kid!(user: user)

    get new_kid_reported_symptom_path(kid)
    expect(response).to have_http_status(:ok)
  end

  it "start_recordで病気記録を開始できる（DiseaseRecordが1件増える）" do
    user = create_user!(email: "rs_start@example.com")
    sign_in user
    kid = create_kid!(user: user)

    expect do
      post start_record_kid_reported_symptoms_path(kid)
    end.to change(DiseaseRecord, :count).by(1)

    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(new_kid_reported_symptom_path(kid))
  end

  it "症状をcreateできる（ReportedSymptomが1件増える）" do
    user = create_user!(email: "rs_create@example.com")
    sign_in user
    kid = create_kid!(user: user)

    # 記録開始
    post start_record_kid_reported_symptoms_path(kid)

    symptom = create_symptom_name!(name: "咳")

    expect do
      post kid_reported_symptoms_path(kid), params: {
        reported_symptom: { symptom_name_id: symptom.id }
      }
    end.to change(ReportedSymptom, :count).by(1)

    expect(response).to have_http_status(:found)
    expect(response).to redirect_to(new_kid_reported_symptom_path(kid))
  end

  it "summaryが表示できる" do
    user = create_user!(email: "rs_summary@example.com")
    sign_in user
    kid = create_kid!(user: user)

    post start_record_kid_reported_symptoms_path(kid)

    get summary_kid_reported_symptoms_path(kid)
    expect(response).to have_http_status(:ok)
  end
end
