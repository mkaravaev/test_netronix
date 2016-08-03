require 'json'
require './lib/models/user'
require './lib/models/task'
require_relative 'user_type_searcher_middleware'
require 'rack/contrib'

class App < Sinatra::Base
  use Rack::PostBodyContentTypeParser 
  use UserTypeSearcherMiddleware

  before do
    content_type :json
  end

  set(:auth) do |*user_types|
    condition do
      user_type = request.env.fetch('user_type', [])
      unless user_types.include?(user_type)
        halt 404, {'Content-Type' => 'application/json'}, 'not authorized'
      end
    end
  end

  get '/users' do
    @users = User.all
    json @users.to_a
  end

  post "/users" do
    @user = User.new(params[:user])
    if @user.save
      json status: :ok
    else
      status 422
      json status: [@user.errors]
    end
  end

  get "/tasks", auth: :driver do
    @tasks = Task.nearest(params[:lat], params[:lng])
    if @tasks.present?
      json @tasks
    else
      status 422
      json status: "no tasks"
    end
  end

  post "/tasks", auth: :manager do
    @user = User.find_by({token: params[:token]})
    @task = @user.created_tasks.build(params[:task])
    if @task.save
      json status: :ok
    else
      status 422
      json status: [@task.errors]
    end
  end

  put "/tasks/assign", auth: :driver do
    @user = User.find_by(token: params[:token])
    @task = Task.find(params[:id])

    if @task.assign_to!(@user)
      json status: :assigned
    else
      status 422
      json status: [@task.errors]
    end
  end

  put "/tasks/done", auth: :driver do
    @task = Task.find(params[:id])
    @user = User.find_by(token: params[:token])

    if @task.done_by!(@user)
      json status: :done
    else
      status 422
      json status: [@task.errors]
    end
  end

  helpers do
    def json(obj = {})
      obj.to_json
    end
  end
end

