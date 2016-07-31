class Task
  include Mongoid::Document

  STATES = %i(new assigned done)

  field :description, type: String
  field :state, type: Symbol, default: :new
  field :pickup, type: Array
  field :delivery, type: Array
  field :executor, type: String

  validates :state, inclusion: { in: STATES }

  has_one :owner, ->{ where(type: :manager) }, class_name: "User"
  has_one :executor, ->{ where(type: :manager) }, class_name: "User"


  def assign!
    self.update({state: :assigned!})
  end

  def done!
    self.update({state: :done})
  end

  def self.nearest_for(lat, lng)
    pickup.geo_near([lat, lng])
  end
end
