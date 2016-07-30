require 'models/user'
require 'json'

class App < Sinatra::Base

 # get "/tasks" do
 #   @tasks = Task.all_for_user(user)
 #   json @tasks
 # end

  post "/users" do
    @user = User.new(params[:user])
    if @user.save
      content_type :json
      {status: :ok}.to_json
    else
      content_type :json
      {status: :error}.to_json
    end
  end
end
