require 'test_helper'
require 'app'
require 'json'
require 'models/user'

class AppTest < Minitest::Spec
  include Rack::Test::Methods

  def app
    App
  end

  def test_create_user
    post_json("/users", user: { name: 'John', type: :manager })
    expected = { status: "ok" }.to_json
    assert_equal 1, User.count
    assert_equal expected, last_response.body
  end

  private

  def post_json(uri, json)
    post(uri, json, format: :json, content_type: 'application/json')
  end

end
