class LikesController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    @likes = @user.likes.order(created_at: :desc)
  end

  def create
    @like = Like.new(like_params)

    if @like.save
      redirect_back fallback_location: root_path, notice: "Like was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_back fallback_location: root_path, notice: "Like was successfully destroyed."
  end

  private

  # Only allow a list of trusted parameters through.
  def like_params
    params.require(:like).permit(:user_id, :tweet_id)
  end
end
