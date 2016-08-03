require 'test_helper'
require 'app'
require 'json'
require 'models/user'

class AppTest < Minitest::Spec
  include Rack::Test::Methods

  def app
    App
  end

  def setup
    @manager = User.create({name: "Mr. Manager", type: :manager})
    @driver = User.create({name: "Mr.Driver", type: :driver})
    @task = @manager.created_tasks.create({
      description: "Awesome task",
      pickup: [12.0, 12.0],
      delivery: [13.1, 12.0]
    })
  end

  def test_create_user
    count = User.count
    post_json("/users", user: { name: 'John', type: :manager })
    expected = { status: "ok" }.to_json
    assert_equal count + 1, User.count
    assert_equal expected, last_response.body
  end

  def test_get_tasks_by_geo_coordinates
    get_json("/tasks", { token: @driver.token, lat: 12.0, lng: 12.0 })
    assert_equal [@task].to_json, last_response.body
  end

  def test_create_task_by_manager
    count = Task.count
    post_json("/tasks", task_attrs)
    assert_equal count + 1, Task.count
    assert_equal @manager, Task.last.creator
  end

  def test_assign_task_by_driver
    params = {
      token: @driver.token,
      id: @task.id
    }
    put_json("/tasks/assign", params)
    assert_equal :assigned, Task.find(@task.id).state
  end

  def test_done_task_by_driver
    @task.assign_to!(@driver)
    params = {
      token: @driver.token,
      id: @task.id
    }
    put_json("/tasks/done", params)
    assert_equal :done, Task.find(@task.id).state
  end

  private

  def post_json(uri, json)
    post(uri, json.to_json, {'CONTENT_TYPE' => 'application/json'})
  end

  def get_json(uri, params)
    get(uri, params, {'CONTENT_TYPE' => 'application/json'})
  end

  def put_json(uri, json)
    put(uri, json.to_json, {'CONTENT_TYPE' => 'application/json'})
  end

  def task_attrs
    {
      task: {
        description: "piano",
        pickup: [32.12, 43.32],
        delivery: [32.12, 43.33]
      },
      token: @manager.token
    }
  end

end

