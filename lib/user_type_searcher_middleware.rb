class UserTypeSearcherMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env) 
    write_token
    @app.call(@request.env)
  end

  private

  def write_token
    token = @request.params.fetch("token", false)
    user = User.by_token(token).first

    if token.present? && user.present?
      @request.env["user_type"] = user.type
    end
  end

end

