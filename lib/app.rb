require 'json'
require './lib/models/user'
require_relative 'token_check_middleware'

class App < Sinatra::Base
  use UserTypeSearcherMiddleware

  before do
    content_type :json
  end

  set(:auth) do |*user_types|
    condition do
      unless user_types.include?(params[:user_type])
        render 401
      end
    end
  end

  get '/' do
    json "hello world"
  end

  post "/users" do
    @user = User.new(params[:user])
    if @user.save
      json status: :ok
    else
      status 400
      json status: "not_saved"
    end
  end

  private

  def json(obj = {})
    obj.to_json
  end

  def render_401
     [401, {'Content-Type' => 'application/json'}, ['not suitable token']]
  end
end

