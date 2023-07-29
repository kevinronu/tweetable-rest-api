module Api
  class TweetsController < ApiController
    before_action :require_login!, except: %i[index show]

    # GET /api/tweets
    def index
      tweets = Tweet.all
      tweets_data = []
      tweets.each do |tweet|
        user = tweet.user
        tweet_data = tweet.as_json(
          except: %i[user_id]
        ).merge(
          username: user.username
        )
        tweets_data.push(tweet_data)
      end
      render json: tweets_data, status: :ok
    end

    # GET /api/tweets/:id
    def show
      tweet = Tweet.find(params[:id])
      user = tweet.user
      tweet_data = tweet.as_json(
        except: %i[user_id]
      ).merge(
        username: user.username
      )
      render json: tweet_data, status: :ok
    end
  end
end
