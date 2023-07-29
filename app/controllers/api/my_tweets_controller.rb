module Api
  class MyTweetsController < ApiController
    # GET /api/my_tweets
    def index
      my_tweets = Tweet.where(user_id: current_user.id).order(created_at: :desc)
      my_tweets_data = []
      my_tweets.each do |tweet|
        my_tweets_data.push(tweet_data(tweet))
      end
      render json: my_tweets_data, status: :ok
    end

    private

    def tweet_data(tweet)
      user = tweet.user
      tweet.as_json(except: %i[user_id]).merge(username: user.username)
    end
  end
end
