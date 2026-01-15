require "rails_helper"

RSpec.describe "Kids", type: :request do
  describe "GET /kids" do
    it "未ログインはログイン画面へリダイレクト" do
      get kids_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "ログイン済みなら表示できる" do
      user = create_user!
      sign_in user

      get kids_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /kids/new" do
    it "ログイン済みなら表示できる" do
      user = create_user!(email: "newkid@example.com")
      sign_in user

      get new_kid_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /kids" do
    it "作成できる" do
      user = create_user!(email: "createkid@example.com")
      sign_in user

      expect do
        post kids_path, params: { kid: { name: "Hanako", birthday: "2020-01-01" } }
      end.to change(Kid, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(kids_path)
    end
  end

  describe "GET /kids/:id" do
    it "詳細が表示できる" do
      user = create_user!(email: "showkid@example.com")
      sign_in user
      kid = create_kid!(user: user)

      get kid_path(kid)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /kids/:id/select" do
    it "進行中の病気記録がなければ new_record=true で new に飛ぶ" do
      user = create_user!(email: "selectkid@example.com")
      sign_in user
      kid = create_kid!(user: user)

      get select_kid_path(kid)

      expect(response).to have_http_status(:found)
      expect(response.location).to include("/kids/#{kid.id}/reported_symptoms/new")
      expect(response.location).to include("new_record=true")
    end

    it "進行中の病気記録があればそのまま new に飛ぶ（new_recordなし）" do
      user = create_user!(email: "selectkid2@example.com")
      sign_in user
      kid = create_kid!(user: user)
      create_disease_record!(kid: kid, start_at: Time.current, end_at: nil)

      get select_kid_path(kid)

      expect(response).to have_http_status(:found)
      expect(response.location).to include("/kids/#{kid.id}/reported_symptoms/new")
      expect(response.location).not_to include("new_record=true")
    end
  end
end
