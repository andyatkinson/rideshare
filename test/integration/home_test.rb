require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "smoke test" do
    get '/'
    assert_response :success
  end
end
