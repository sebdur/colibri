class ApplicationController < ActionController::Base
  helper_method :resource_name, :resource, :devise_mapping, :resource_class
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?
  skip_authorization_check :only => [:new, :create]

  before_action :configure_permitted_parameters, if:  :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
