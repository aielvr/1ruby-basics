class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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

class Route
  attr_reader :stations

  def initialize(start_station, finish_station)
    @stations = [start_station, finish_station]
  end

  def add_station(station)
    return if stations.include?(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    stations.delete(station) if stations.index(station) != 0 && stations.index(station) != stations.length - 1
  end
end

class Train
  attr_accessor :speed
  attr_reader :carriages_quantity, :route, :current_station, :number, :type

  def initialize(number, type, carriages_quantity)
    @number = number
    @type = type
    @carriages_quantity = carriages_quantity
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    @carriages_quantity += 1 if speed.zero?
  end

  def remove_carriage
    @carriages_quantity -= 1 if speed.zero?
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
    station_index = route.stations.index(current_station)

    return if !route && station_index.zero?

    route.stations[station_index - 1]
  end

  def next_station
    station_index = route.stations.index(current_station)

    return if !route && station_index == route.stations.length - 1

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
end
