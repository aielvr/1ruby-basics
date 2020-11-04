class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    @trains << train unless @trains.include?(train)
  end

  def dispatch_train(train)
    @trains.delete(train)
  end

  def show_trains
    @trains.each { |train| puts train }
  end

  def show_type_sorted_trains
    passenger_trains = @trains.select {|train| train.type == 'passenger'}
    freight_trains = @trains.select {|train| train.type == 'freight'}
    puts "Количество пассажирских: #{passenger_trains.length}"
    passenger_trains.each { |train| puts train }
    puts "Количество грузовых: #{freight_trains.length}"
    freight_trains.each { |train| puts train }
  end
end

class Route
  attr_reader :stations

  def initialize(start_station, finish_station)
    @stations = [start_station, finish_station]
  end

  def add_station(station)
    unless stations.include?(station)
      finish_index = stations.length - 1

      finish_station = stations.pop
      stations[finish_index] = station
      stations.push(finish_station)
    end
  end

  def remove_station(station)
    stations.delete(station) if stations.index(station) != 0 && stations.index(station) != stations.length - 1
  end

  # что выводить требуется наименования или станции как объекты
  def show_stations
    stations.each { |station| puts station }
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
      cur_station_index = self.route.stations.index(current_station)
      route.stations[cur_station_index].dispatch_train(self)
    end

    @route = new_route

    @current_station = self.route.stations[0]
    self.route.stations[0].take_train(self)
  end

  def prev_station
    station_index = route.stations.index(current_station)
    if route && !station_index.zero?
      route.stations[station_index - 1]
    end
  end

  def next_station
    station_index = route.stations.index(current_station)
    if route && station_index != route.stations.length - 1
      route.stations[station_index + 1]
    end
  end

  def move_forward
    if route
      cur_station_index = route.stations.index(current_station)
      if cur_station_index != route.stations.length - 1
        next_station_index = route.stations.index(next_station)

        route.stations[cur_station_index].dispatch_train(self)
        @current_station = next_station
        route.stations[next_station_index].take_train(self)
      end
    end
  end

  def move_back
    if route
      cur_station_index = route.stations.index(current_station)

      if cur_station_index != 0
        puts("nihao")
        prev_station_index = route.stations.index(prev_station)

        route.stations[cur_station_index].dispatch_train(self)
        @current_station = prev_station
        route.stations[prev_station_index].take_train(self)
      end
    end
  end

end