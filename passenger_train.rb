require_relative 'instance_counter'

class PassengerTrain < Train
  include InstanceCounter
  @instance_counter = 0

  def initialize(number)
    super(number)
    @type = :passenger
  end
end
