class Api::V1::SessionsController < Api::V1::BaseController 
  skip_before_action :authenticate_api_user!, only: [:create] 
  #POST /api/v1/login 
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { 
        api_token: user.api_token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  #GET /api/v1/me 
  def me
    render json: UserSerializer.new(current_user).serializable_hash
  end

  #POST /api/v1/logout 
  def destroy 
    current_user.regenerate_api_token
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
