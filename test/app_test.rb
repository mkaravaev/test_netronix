require 'test_helper'
require 'app'
require 'json'
require 'models/user'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_create_user
    post_json("/users", {name: 'John', type: 'manager' }.to_json)
    expected = { status: :created }
    assert_equel 1, User.count
    assert_equal expected, last_response.body
  end

  private

  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json" })
  end

end
