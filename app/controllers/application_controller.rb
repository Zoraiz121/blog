class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authorizable

  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ==> Devise permitted parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [ :name, :occupation ]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [ :name, :occupation ]
    )
  end
end
