require 'models/user'
require 'json'

class App < Sinatra::Base
  before do
    content_type :json
  end

 # get "/tasks" do
 #   @tasks = Task.all_for_user(user)
 #   json @tasks
 # end

  post "/users" do
    @user = User.new(params[:user])
    if @user.save
      json status: :ok
    else
      json status: :error
    end
  end

  private

  def json(obj = {})
    obj.to_json
  end
end
