require "rails_helper"

describe "Users", type: :request do
  def auth_headers(token)
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  let(:valid_attributes) do
    { name: "Testino Di Prueba", username: "testino", email: "testino@example.com",
      password: "qwerty" }
  end

  let(:invalid_attributes) do
    { name: "Testino Di Prueba", username: "testino", email: "testino@example.com",
      password: "123" }
  end

  it "creates a user with valid attributes" do
    expect do
      post "/api/users", params: valid_attributes
    end.to change(User, :count).by(1)
    user_data = response.parsed_body
    expect(response).to have_http_status(:created)
    expect(user_data).to include("id")
    expect(user_data).to include("name")
    expect(user_data).to include("username")
    expect(user_data).to include("email")
    expect(user_data).to include("role")
    expect(user_data).to include("token")
    expect(user_data).to include("created_at")
    expect(user_data).to include("updated_at")
  end

  it "returns unprocessable entity with invalid attributes" do
    post "/api/users", params: invalid_attributes
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "updates the user profile" do
    post "/api/users", params: valid_attributes
    user_data = response.parsed_body
    token = user_data["token"]
    user = User.find(user_data["id"])
    new_attributes = { name: "New Testino" }

    patch "/api/profile", params: new_attributes, headers: auth_headers(token)

    expect(response).to have_http_status(:ok)
    expect(user.reload.name).to eq("New Testino")
  end

  it "returns errors if update fails" do
    post "/api/users", params: valid_attributes
    user_data = response.parsed_body
    token = user_data["token"]
    new_attributes = { name: "" }

    patch "/api/profile", params: new_attributes, headers: auth_headers(token)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.parsed_body["errors"]).to_not be_empty
  end

  it "login a user with valid credentials" do
    post "/api/users", params: valid_attributes
    post "/api/login",
         params: { email: valid_attributes[:email], password: valid_attributes[:password] }
    user_data = response.parsed_body
    expect(response).to have_http_status(:ok)
    expect(user_data).to include("id")
    expect(user_data).to include("name")
    expect(user_data).to include("username")
    expect(user_data).to include("email")
    expect(user_data).to include("role")
    expect(user_data).to include("token")
  end

  it "returns unauthorized with invalid credentials" do
    post "/api/users", params: valid_attributes
    post "/api/login", params: { email: valid_attributes[:email], password: "wrong_password" }
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to include("Invalid credentials")
  end

  it "logout a user" do
    post "/api/users", params: valid_attributes
    user_data = response.parsed_body
    token = user_data["token"]
    user = User.find(user_data["id"])
    delete "/api/logout", headers: auth_headers(token)
    expect(response).to have_http_status(:no_content)
    user.reload
    expect(user.token).to be_nil
  end

  it "returns unauthorized if user is not logged in" do
    post "/api/users", params: valid_attributes
    delete "/api/logout"
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to include("Invalid credentials")
  end
end
