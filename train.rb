require_relative 'produced_by_module'
require_relative 'instance_counter'
require_relative 'validation_module'
require_relative 'accessors_module'

class Train
  include ProducedBy
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor_with_history :number, :speed
  attr_reader :route, :current_station, :type, :wagons

  NUMBER_FORMAT = /[а-я, 0-9]{3}\-?[а-я, 0-9]{2}/i

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  @@instances = []

  def self.find(train_number)
    @@instances.detect { |instance| instance.number == train_number }
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []

    validate!
    @@instances.push(self)
    register_instance
  end

  def stop
    self.speed = 0
  end

  def route=(new_route)
    if route
      cur_station_index = route.stations.index(current_station)
      route.stations[cur_station_index].dispatch_train(self)
    end

    @route = new_route

    @current_station = route.stations[0]
    route.stations[0].take_train(self)
  end

  def prev_station
    return unless route

    station_index = route.stations.index(current_station)

    return if station_index.zero?

    route.stations[station_index - 1]
  end

  def next_station
    return unless route

    station_index = route.stations.index(current_station)

    return if station_index == route.stations.length - 1

    route.stations[station_index + 1]
  end

  def move_forward
    return unless next_station

    current_station.dispatch_train(self)
    @current_station = next_station
    current_station.take_train(self)
  end

  def move_back
    return unless prev_station

    current_station.dispatch_train(self)
    @current_station = prev_station
    current_station.take_train(self)
  end

  def remove_wagon
    last_wagon_index = wagons.length - 1
    wagons.delete_at(last_wagon_index) if speed.zero?
  end

  def add_wagon(wagon)
    return if wagons.include?(wagon)

    wagons << wagon if speed.zero? && suitable_wagon?(wagon)
  end

  def handle_wagons
    wagons.each do |wagon|
      yield(wagon)
    end
  end

  # def valid?
  #   validate!
  #   true
  # rescue StandardError
  #   false
  # end

  protected

  attr_writer :wagons

  # нет необходимости использовать данный метод через интерфейс
  def suitable_wagon?(wagon)
    wagon.type == type
  end

  # def validate!
  #   raise "Number can't be nil" if number.nil?
  #   raise "Number can't be empty string" if number.empty? # #|| number.chomp.empty?
  #   raise 'Number has invalid format' if number !~ NUMBER_FORMAT
  # end
end
