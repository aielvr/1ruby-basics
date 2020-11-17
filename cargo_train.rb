require_relative 'instance_counter'

class CargoTrain < Train
  include InstanceCounter
  @instance_counter = 0

  def initialize(number)
    super(number)
    @type = :cargo
  end
end
