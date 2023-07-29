class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]

  # GET /login
  def new
    # render "new"
  end

  # POST /sessions
  def create
    if auth_hash
      if auth_hash.info.email.nil?
        flash[:warning] = "Email address is not available."
        redirect_to root_path
        return
      end
      user = User.find_by(email: auth_hash.info.email)

      user ||= User.create(
        name: auth_hash.info.name,
        username: auth_hash.info.nickname,
        email: auth_hash.info.email,
        password: SecureRandom.urlsafe_base64
      )
    else
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        log_in(user)
      else
        flash.now[:warning] = "Invalid Credentials"
        render "new", status: :unprocessable_entity
        return
      end
    end
    
    log_in(user)
    redirect_to root_path
  end

  # DELETE /logout
  def destroy
    logout
    redirect_to root_path, status: :see_other
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
