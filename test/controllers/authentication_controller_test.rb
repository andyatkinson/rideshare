require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "POST to login with correct user credentials" do
    post auth_login_url, params: {
      email: rider.email,
      password: "abcd1234"
    }

    assert_response :ok
    assert jwt_payload = JSON.parse(response.body)
    assert jwt_payload.has_key?('token')
    assert jwt_payload.has_key?('exp')
    assert jwt_payload.has_key?('username')

    assert_equal rider.display_name, jwt_payload['username']
  end

  test "POST to login with INVALID credentials" do
    post auth_login_url, params: {
      email: rider.email,
      password: "abcd123"
    }

    assert_response :unauthorized
  end

  private

  def rider
    # Rider has the hashed password for "abcd1234"
    # Stored in the field `password_digest`
    @rider ||= riders(:jane)
  end
end
