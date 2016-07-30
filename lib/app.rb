require 'models/user'
require 'json'

class App < Sinatra::Base

 # get "/tasks" do
 #   @tasks = Task.all_for_user(user)
 #   json @tasks
 # end

  post "/users" do
    @user = User.new(parsed_params)
    if @user.save
      content_type :json
      {stautus: :ok}.to_json
    else
      content_type :json
      {status: :error}.to_json
    end
  end

  private

  def parsed_params
    JSON.parse(params[:user])
  end
end
