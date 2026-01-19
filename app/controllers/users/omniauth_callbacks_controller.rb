class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except("extra")
      msg = user&.errors&.full_messages&.join(", ").presence || "Googleアカウントでの登録に失敗しました。"
      redirect_to new_user_registration_url, alert: msg
    end
  end

  def failure
    redirect_to root_path, alert: "Googleログインに失敗しました。"
  end
end
