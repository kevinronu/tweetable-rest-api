module Api
  class SessionsController < ApiController
    skip_before_action :require_login!

    # POST /api/login
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        user.regenerate_token
        user_data = user.as_json(
          except: %i[password_digest]
        )
        render json: user_data
      else
        render_unauthorized("Invalid credentials")
      end
    end

    # DELETE /api/logout
    def destroy
      return current_user.update(token: nil) unless current_user.nil?

      render_unauthorized("Invalid credentials")
    end
  end
end
