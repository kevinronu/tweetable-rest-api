module Api
  class TweetsController < ApiController
    before_action :require_login!, except: %i[index show]
    before_action :set_tweet, only: %i[show update destroy]

    # GET /api/tweets
    def index
      tweets = Tweet.all
      tweets_data = []
      tweets.each do |tweet|
        tweets_data.push(tweet_data(tweet))
      end
      render json: tweets_data, status: :ok
    end

    # GET /api/tweets/:id
    def show
      render json: tweet_data(@tweet), status: :ok
    end

    # POST /api/tweets
    def create
      @tweet = Tweet.new(user_id: current_user.id, body: params[:body])

      if @tweet.save
        render json: tweet_data(@tweet), status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/tweets/1
    def update
      if @tweet.user_id == current_user.id || current_user.role == "admin"
        if @tweet.update(tweet_params)
          render json: tweet_data(@tweet)
        else
          render json: @tweet.errors, status: :unprocessable_entity
        end
      else
        render_unauthorized("Invalid credentials")
      end
    end

    # DELETE /api/tweets/1
    def destroy
      if @tweet.user_id == current_user.id || current_user.role == "admin"
        @tweet.destroy
      else
        render_unauthorized("Invalid credentials")
      end
    end

    private

    def tweet_data(tweet)
      user = tweet.user
      tweet.as_json(except: %i[user_id]).merge(username: user.username)
    end

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.permit(:body)
    end
  end
end
