require "rails_helper"

describe "Likes", type: :request do
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

  it "creates a Like with valid attributes" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_id = response.parsed_body["id"]
    expect do
      post "/api/likes", params: { tweet_id: }, headers: auth_headers(token)
    end.to change(Like, :count).by(1)
    like_data = response.parsed_body

    expect(response).to have_http_status(:created)
    expect(like_data).to include("id")
    expect(like_data).to include("tweet_id")
    expect(like_data).to include("created_at")
    expect(like_data).to include("updated_at")
    expect(like_data).not_to include("user_id")
  end

  it "creates a Like with invalid attributes" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/likes", params: { tweet_id: 1 }, headers: auth_headers(token)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]).to_not be_empty
  end

  it "show a valid Like" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_id = response.parsed_body["id"]
    post "/api/likes", params: { tweet_id: }, headers: auth_headers(token)
    like_data = response.parsed_body
    like_id = like_data["id"]
    get "/api/likes/#{like_id}"

    expect(response).to have_http_status(:ok)
    expect(like_data).to include("id")
    expect(like_data).to include("tweet_id")
    expect(like_data).to include("created_at")
    expect(like_data).to include("updated_at")
    expect(like_data).not_to include("user_id")
    expect(like_data).to include("username")
  end

  it "show a invalid Tweet" do
    get "/api/likes/1"

    expect(response).to have_http_status(:not_found)
  end

  it "delete like" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_id = response.parsed_body["id"]
    post "/api/likes", params: { tweet_id: }, headers: auth_headers(token)
    like_data = response.parsed_body
    like_id = like_data["id"]
    delete "/api/likes/#{like_id}", headers: auth_headers(token)

    expect(response).to have_http_status(:no_content)
  end

  it "returns errors if delete invalid tweet" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    delete "/api/likes/1", headers: auth_headers(token)

    expect(response).to have_http_status(:not_found)
  end

  it "returns errors if delete a tweet without token" do
    post "/api/users", params: valid_user_attributes
    token = response.parsed_body["token"]
    post "/api/tweets", params: valid_tweet_attributes, headers: auth_headers(token)
    tweet_id = response.parsed_body["id"]
    post "/api/likes", params: { tweet_id: }, headers: auth_headers(token)
    like_data = response.parsed_body
    like_id = like_data["id"]
    delete "/api/likes/#{like_id}"

    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body["errors"]).to include("Access Denied")
  end
end
