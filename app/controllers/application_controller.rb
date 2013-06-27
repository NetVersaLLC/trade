class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  # strong parameters is mandatory in rails4
  # see http://devise.plataformatec.com.br/#getting-started/strong-parameters for details
  def configure_permitted_parameters
    sign_up_vars = [:email, :password, :password_confirmation, :current_password, :address, :name,
                      :address, :phone, :skype, :aim, :yim, :jabber, :latitude, :longitude]

    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(sign_up_vars) }
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(sign_up_vars) }

  end
end
