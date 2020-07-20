class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout :determine_layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :address, roles: [])}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :current_password, :address, roles: []) }
  end

  def determine_layout
    if user_signed_in?
      if current_user.admin?
        'admin'
      else
        'users'
      end
    else
      'application'
    end
  end
end