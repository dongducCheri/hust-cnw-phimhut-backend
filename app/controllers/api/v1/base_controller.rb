class Api::V1::BaseController < ApplicationController
  before_action :authenticate_api_user!
  attr_reader :current_user
  
  private
  def authenticate_api_user!
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by(api_token: token) if token.present?
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def require_admin!
    render json: { error: 'Forbidden' }, status: :forbidden unless @current_user&.admin?
  end


end
