class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :require_login!

  def require_login!
    current_user || render_unauthorized("Login to perform this action")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  def render_unauthorized(error_message)
    render json: { errors: error_message }, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      User.find_by(token:)
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |error|
    render json: { error: error.message }, status: :not_found
  end
end
