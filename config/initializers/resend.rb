require "resend"

api_key = ENV["RESEND_API_KEY"]

if api_key.present?
  Resend.api_key = api_key
else
  Rails.logger.warn("[Resend] RESEND_API_KEY is not set. Email sending is disabled in this environment.")
end
