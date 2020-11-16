require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances.push(self)
    register_instance
  end

  def take_train(train)
    trains << train unless @trains.include?(train)
  end

  def dispatch_train(train)
    trains.delete(train)
  end

  def show_type_sorted_trains
    trains.sort_by(&:type)
  end
end