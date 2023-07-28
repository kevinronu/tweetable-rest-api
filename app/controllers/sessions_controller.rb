class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]

  # GET /login
  def new
    # render "new"
  end

  # POST /sessions
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      log_in(user)

      redirect_to root_path
    else
      flash.now[:warning] = "Invalid Credentials"
      render "new", status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    logout
    redirect_to root_path, status: :see_other
  end
end
