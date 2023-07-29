module Api
  class TweetsController < ApiController
    # GET /api/tweets
    def index
      tweets = Tweet.all
      render json: tweets, status: :ok
    end

    # GET /api/tweets/:id
    def show
      tweet = Tweet.find(params[:id])
      render json: tweet, status: :ok
    end
  end
end
