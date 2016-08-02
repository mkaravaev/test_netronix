class User
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  TYPES = %i(manager driver)

  field :name, type: String
  field :type, type: Symbol
  field :token, type: String

  validates_presence_of :token, :type
  validates :type, inclusion: { in: TYPES }

  has_many :created_tasks, class_name: "Task", inverse_of: :creator
  has_many :accepted_tasks, class_name: "Task", inverse_of: :executor

  before_validation :generate_token

  scope :manager, ->{ where(type: :manager) }
  scope :driver, ->{ where(type: :driver) }
  scope :by_token, ->(token){ where(token: token)}

  private

  def generate_token
    self.token = SecureRandom.base64
  end
end
