class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: [:create]

  # POST /api/v1/signup
  def create
    user = User.new(user_params)
    if user.save
      render json: {
        api_token: user.api_token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          balance: user.balance
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
