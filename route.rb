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
