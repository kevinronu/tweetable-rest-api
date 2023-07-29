module Api
  class MyLikesController < ApiController
    # GET /api/my_likes
    def index
      my_likes = Like.where(user_id: current_user.id).order(created_at: :desc)
      my_likes_data = []
      my_likes.each do |like|
        my_likes_data.push(like_data(like))
      end
      render json: my_likes_data, status: :ok
    end

    private

    def like_data(like)
      tweet = like.tweet
      user = tweet.user
      like.as_json(except: %i[user_id]).merge(
        tweet: tweet.as_json(except: %i[id user_id]).merge(username: user.username)
      )
    end
  end
end
