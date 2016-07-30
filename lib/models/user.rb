class User
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  before_save :generate_token
  field :name, type: String
  field :type, type: String
  field :token, type: String

  private

  def generate_token
    self.token = SecureRandom.base64
  end
end
