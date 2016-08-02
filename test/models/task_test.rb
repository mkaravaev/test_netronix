require 'models/task'
require 'test_helper'
require 'app'
require 'models/user'

class TaskTest < Minitest::Spec

  def setup
    @manager = User.create({ name: "Manager", type: :manager })
    @driver = User.create({ name: "Driver", type: :driver })

    @task = @manager.created_tasks.create({
      description: "test",
      pickup: [100.123, 100.123],
      delivery: [54.123, 54.123]
    })
  end

  def test_not_allowed_to_create_task_by_driver
    new_task = @driver.created_tasks.create({
      description: "test",
      pickup: [100.123, 100.123],
      delivery: [54.123, 54.123]
    })

    expected_error = { "creator": ['is not manager'] }
    assert_equal expected_error, new_task.errors.messages
  end

  def test_assign_to_should_change_task_state_for_driver
    @task.assign_to!(@driver) 
    assert_equal :assigned, @task.state
  end

  def test_assign_to_should_not_change_task_state_for_manager
    manager2 = User.create({ name: "Manager2", type: :manager })
    expected_error = { "executor": ['is not driver'] }
    @task.assign_to!(manager2)

    assert_equal :new, @task.state
    assert_equal expected_error, @task.errors.messages
  end
end

