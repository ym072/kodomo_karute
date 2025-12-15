class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_kid, if: :user_signed_in?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    kids_path
  end

  def after_sign_up_path_for(resource)
    kids_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def set_current_kid
    if params[:kid_id].present?
      @current_kid = current_user.kids.find_by(id: params[:kid_id])
      session[:current_kid_id] = @current_kid.id if @current_kid
    elsif session[:current_kid_id].present?
      @current_kid = current_user.kids.find_by(id: session[:current_kid_id])
    else
      @current_kid = nil
    end
  end
  
  helper_method :current_kid
  def current_kid
    @current_kid
  end
end
