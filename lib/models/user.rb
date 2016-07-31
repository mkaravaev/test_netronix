class User
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  TYPES = %i(manager driver)

  field :name, type: String
  field :type, type: Symbol
  field :token, type: String

  validates_presence_of :token, :type
  validates :type, inclusion: { in: TYPES }

  has_many :tasks

  scope :manager, ->{ where(type: :manager) }
  scope :driver, ->{ where(type: :manager) }
  scope :by_token, ->(token){ where(token: token)}

  before_save :generate_token

  private

  def generate_token
    self.token = SecureRandom.base64
  end
end
