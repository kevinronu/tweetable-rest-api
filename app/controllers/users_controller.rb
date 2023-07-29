class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create show]

  # GET /users/:username
  def show
    @user = User.find_by(username: params[:username])
    @my_tweets = Tweet.where(user_id: @user.id).order(created_at: :desc)
  end

  # GET /signup
  def new
    @user = User.new
  end

  # GET /profile
  def edit
    @user = current_user
  end

  # POST /signup
  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)

      redirect_to user_path(current_user.username), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /profile
  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_path(current_user.username), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])

    if current_user.role == "admin"
      @user.destroy
      redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
    else
      redirect_to root_path, status: :forbidden
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :username, :email, :avatar, :password,
                                 :password_confirmation)
  end
end
