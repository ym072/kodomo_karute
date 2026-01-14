require "rails_helper"

RSpec.describe "Pages", type: :request do
  it "rootが表示できる" do
    get root_path
    expect(response).to have_http_status(:ok)
  end

  it "termsが表示できる" do
    get "/terms"
    expect(response).to have_http_status(:ok)
  end

  it "privacyが表示できる" do
    get "/privacy"
    expect(response).to have_http_status(:ok)
  end
end
