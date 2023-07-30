module Api
  class LikesController < ApiController
    before_action :require_login!, except: %i[index show]
    before_action :set_like, only: %i[show destroy]

    # GET /api/likes
    def index
      likes = Like.order(created_at: :desc)
      likes_data = []
      likes.each do |like|
        likes_data.push(like_data(like))
      end
      render json: likes_data, status: :ok
    end

    # GET /api/likes/:id
    def show
      render json: like_data(@like), status: :ok
    end

    # POST /api/likes
    def create
      @like = Like.new(user_id: current_user.id, tweet_id: params[:tweet_id])

      if @like.save
        render json: like_data(@like), status: :created
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/likes/1
    def destroy
      if @like.user_id == current_user.id || current_user.role == "admin"
        @like.destroy
      else
        render_unauthorized("Invalid credentials")
      end
    end

    private

    def like_data(like)
      user = like.user
      like.as_json(except: %i[user_id]).merge(username: user.username)
    end

    def set_like
      @like = Like.find(params[:id])
    end

    def like_params
      params.permit(:tweet_id)
    end
  end
end
