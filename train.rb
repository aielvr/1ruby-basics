class Train
  attr_accessor :speed
  attr_reader :route, :current_station, :number, :type, :wagons

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
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

  protected

  attr_writer :wagons

  # нет необходимости использовать данный метод через интерфейс
  def suitable_wagon?(wagon)
    wagon.type == type
  end

  # реализация данного метода предназначена исключительно для его дальнейшего расширения в подклассах;
  # не предполагается их использование извне
  def add_wagon(wagon)
    return if wagons.include?(wagon)

    wagons << wagon if speed.zero?
  end
end
