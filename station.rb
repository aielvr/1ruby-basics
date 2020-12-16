require_relative 'instance_counter'
require_relative 'validation_module'
require_relative 'accessors_module'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  strong_attr_accessor :name, String
  attr_reader :trains

  validate :name, :presence
  validate :name, :type, String

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []

    validate!
    @@instances.push(self)
    register_instance
  end

  def take_train(train)
    trains << train unless @trains.include?(train)
  end

  def dispatch_train(train)
    trains.delete(train)
  end

  def handle_trains
    trains.each do |train|
      yield(train)
    end
  end

  # def validate?
  #   validate!
  #   true
  # rescue StandardError
  #   false
  # end

  def show_type_sorted_trains
    trains.sort_by(&:type)
  end

  # protected

  # def validate!
  #   raise "Station name can't be empty string" if name.chomp.empty?
  # end
end
