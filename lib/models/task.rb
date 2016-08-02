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
  validates_presence_of :creator, :pickup, :delivery
  validate :creator_type, on: :create

  belongs_to :creator, class_name: "User", inverse_of: :created_tasks do
    ->{where(type: :manager)}
  end

  belongs_to :executor, class_name: "User", inverse_of: :accepted_tasks do
    ->{where(type: :driver)}
  end

  scope :nearest, ->(lat,lng){ near({pickup: [lat.to_f, lng.to_f]}) }

  def assign_to!(executor)
    if valid_executor_type?(executor) && self.executor.nil?
      self.update({state: :assigned, executor: executor})
    else
      self.errors.add(:executor, 'is not driver or already exist')
    end
  end

  def done_by!(user)
    if self.executor == user && self.state == :assigned
      self.update({state: :done})
    else
      self.errors.add(
        :executor, 'is not same as assigned or state not appropriate'
      )
    end
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
