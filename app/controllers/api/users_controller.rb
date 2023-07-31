module Api
  class UsersController < ApiController
    skip_before_action :require_login!, only: :create

    # GET /api/profile
    def show
      render json: user_data(current_user)
    end

    # POST /api/users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: user_data(@user), status: :created
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    # PATCH /api/profile
    def update
      if current_user.update(user_params)
        render json: user_data(current_user), status: :ok
      else
        render json: { errors: current_user.errors }, status: :unprocessable_entity
      end
    end

    private

    def user_data(user)
      user.as_json(except: %i[password_digest])
    end

    def user_params
      params.permit(:name, :username, :email, :password)
    end
  end
end
