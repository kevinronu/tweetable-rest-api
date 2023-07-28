class LikesController < ApplicationController
  before_action :set_like, only: %i[destroy]

  def show
    @user = User.find(params[:id])
    @likes = @user.likes.order(created_at: :desc)
  end

  def create
    # binding.pry
    @like = Like.new(like_params)

    if @like.save
      redirect_to fallback_location: root_path, notice: "Like test was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @like.destroy
    redirect_to fallback_location: root_path, notice: "Like was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_like
    @like = Like.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def like_params
    params.require(:like).permit(:user_id, :tweet_id)
  end
end
