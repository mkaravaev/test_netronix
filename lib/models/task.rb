class Task
  include Mongoid::Document

  STATES = %i(new assigned done)

  field :description, type: String
  field :state, type: Symbol, default: :new
  field :pickup, type: Array
  field :delivery, type: Array

  index({ pickup: "2d" })
  index({ delivery: "2d" })

  validates :state, inclusion: { in: STATES }
  validates_presence_of :creator
  validate :creator_type, on: :create

  belongs_to :creator, class_name: "User", inverse_of: :created_tasks do
    ->{where(type: :manager)}
  end

  belongs_to :executor, class_name: "User", inverse_of: :accepted_tasks do
    ->{where(type: :driver)}
  end

  scope :nearest, ->(lat,lng){ near({pickup: [lat, lng]}) }

  def assign_to!(executor)
    if valid_executor_type?(executor)
      self.update({state: :assigned, executor: executor})
    else
      self.errors.add(:executor, 'is not driver')
    end
  end

  def done!
    self.update({state: :done})
  end

  private

  def creator_type
    if self.creator.type != :manager
      errors.add(:creator, "is not manager")
    end
  end

  def valid_executor_type?(obj)
    obj.type == :driver
  end
end
