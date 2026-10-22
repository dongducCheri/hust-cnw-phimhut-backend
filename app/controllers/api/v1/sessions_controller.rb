class Api::V1::SessionsController < Api::V1::BaseController 
  skip_before_action :authenticate_api_user!, only: [:create] 
  #POST /api/v1/login 
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { 
        api_token: user.api_token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          balance: user.balance
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  #GET /api/v1/me 
  def me
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      role: current_user.role,
      balance: current_user.balance
    }, status: :ok
  end

  #POST /api/v1/logout 
  def destroy 
    current_user.regenerate_api_token
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
