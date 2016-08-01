class Task
  include Mongoid::Document

  STATES = %i(new assigned done)

  field :description, type: String
  field :state, type: Symbol, default: :new
  field :pickup, type: Array
  field :delivery, type: Array

  index({pickup: "2d"})
  index({delivery: "2d"})

  validates :state, inclusion: { in: STATES }
  validates_presence_of :initiator

  belongs_to :creator, class_name: "User"
  belongs_to :executor, class_name: "User"

  def assign!
    self.update({state: :assigned!})
  end

  def done!
    self.update({state: :done})
  end

  def self.nearest(lat, lng)
    pickup.geo_near([lat, lng])
  end
end
