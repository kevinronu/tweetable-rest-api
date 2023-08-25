require "rails_helper"

describe "Tweets", type: :request do
  def auth_headers(token)
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  let(:valid_user_attributes) do
    { name: "Testino Di Prueba", username: "testino", email: "testino@example.com",
      password: "qwerty" }
  end

  let(:valid_tweet_attributes) do
    { body: "New Tweet" }
  end

  let(:invalid_tweet_attributes) do
    { body: "This is a very long text that occupies more than one hundred and forty characters, such
      a long tweet should not be allowed, therefore this tweet is not valid" }
  end

  it "creates a Tweet with valid attributes" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    expect do
      post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    end.to change(Tweet, :count).by(1)
    tweet_data = response.parsed_body

    expect(response).to have_http_status(:created)
    expect(tweet_data).to include("id")
    expect(tweet_data).to include("body")
    expect(tweet_data).to include("replies_count")
    expect(tweet_data).to include("likes_count")
    expect(tweet_data).to include("created_at")
    expect(tweet_data).to include("updated_at")
    expect(tweet_data).not_to include("user_id")
    expect(tweet_data).to include("username")
  end

  it "creates a Tweet with invalid attributes" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: invalid_tweet_attributes, headers: auth_headers(token)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]["body"]).to include("is too long (maximum is 140 characters)")
  end

  it "show a valid Tweet" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_data = response.parsed_body
    tweet_id = tweet_data["id"]
    get "/api/tweets/#{tweet_id}"

    expect(response).to have_http_status(:ok)
    expect(tweet_data).to include("id")
    expect(tweet_data).to include("body")
    expect(tweet_data).to include("replies_count")
    expect(tweet_data).to include("likes_count")
    expect(tweet_data).to include("created_at")
    expect(tweet_data).to include("updated_at")
    expect(tweet_data).not_to include("user_id")
    expect(tweet_data).to include("username")
  end

  it "show a invalid Tweet" do
    get "/api/tweets/1"

    expect(response).to have_http_status(:not_found)
  end

  it "update tweet" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_data = response.parsed_body
    tweet_id = tweet_data["id"]
    tweet = Tweet.find(tweet_id)

    new_attributes = { body: "New Body" }
    patch "/api/tweets/#{tweet_id}", params: new_attributes, headers: auth_headers(token)

    expect(response).to have_http_status(:ok)
    expect(tweet.reload.body).to eq("New Body")
  end

  it "returns errors if update tweet fails" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_data = response.parsed_body
    tweet_id = tweet_data["id"]

    new_attributes = { body: "" }
    patch "/api/tweets/#{tweet_id}", params: new_attributes, headers: auth_headers(token)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]).to_not be_empty
  end

  it "delete tweet" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_data = response.parsed_body
    tweet_id = tweet_data["id"]
    delete "/api/tweets/#{tweet_id}", headers: auth_headers(token)

    expect(response).to have_http_status(:no_content)
  end

  it "returns errors if delete invalid tweet" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    delete "/api/tweets/1", headers: auth_headers(token)

    expect(response).to have_http_status(:not_found)
  end

  it "returns errors if delete a tweet without token" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_data = response.parsed_body
    tweet_id = tweet_data["id"]
    delete "/api/tweets/#{tweet_id}"

    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body["errors"]).to include("Access Denied")
  end
end
