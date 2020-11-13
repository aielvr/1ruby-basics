require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'route'

class RailRoad
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  # def seed
  #   st1 = Station.new 'Olympic Village'
  #   stations.push(st1)
  #   st2 = Station.new 'Roza Hutor'
  #   stations.push(st2)
  #   st3 = Station.new 'Hosta'
  #   stations.push(st3)
  #   r1 = Route.new st1, st3
  #   routes.push(r1)
  #   tr1 = CargoTrain.new 125
  #   trains.push(tr1)
  #   tr2 = PassengerTrain.new 267
  #   trains.push(tr2)
  #   tr3 = CargoTrain.new 13
  #   trains.push(tr3)
  #   tr4 = PassengerTrain.new 44
  #   trains.push(tr4)
  # end

  def menu
    puts 'Выберите действие, которое хотите воспроизвести c объектами системы железной дороги'
    puts 'Для создания новой станции/поезда/маршрута введите 1'
    puts 'Для воспроизведения действия над существующими объектами введите 2'
    puts 'Для получения информация об объектах системы введите 3'
    puts 'Для остановки программы введите 0'
    cmd_number = gets.to_i

    return if cmd_number.zero?

    create_new_object if cmd_number == 1
    modify_object if cmd_number == 2
    show_stations_and_trains if cmd_number == 3
  end

  private

  # получение доступа к выполнению всех методов, представленных ниже, предусматривается из метода menu

  def create_new_object
    puts 'Для создания'
    puts 'станции - введите 1'
    puts 'поезда - введите 2'
    puts 'маршрута - введите 3'
    puts 'для возврата в главное меню - введите 0'
    cmd_number = gets.to_i

    menu if cmd_number.zero?
    create_station if cmd_number == 1
    create_train if cmd_number == 2
    create_route if cmd_number == 3
  end

  def create_station
    puts 'Введите наименование для новой станции'
    station_name = gets.chomp

    station = Station.new station_name
    stations.push(station)

    puts "Новая станция с наименованием #{station_name} успешно создана"
    menu
  end

  def create_train
    puts 'Введите номер для нового поезда'
    train_number = gets.to_i
    puts 'Введите тип нового поезда'
    puts '1 - для создания пассажирского поезда'
    puts '2 - для грузового поезда'
    cmd_number = gets.to_i

    case cmd_number
    when 1
      train_type = :passenger
    when 2
      train_type = :cargo
    else
      return
    end

    train_type_name = if train_type == :passenger
                        'пассажирский'
                      else 'грузовой'
                      end

    if train_type == :passenger
      trains.push(PassengerTrain.new(train_number))
    else trains.push(CargoTrain.new(train_number))
    end

    puts "Новый #{train_type_name} поезд с номером #{train_number} успешно создан"
    menu
  end

  def create_route
    puts 'Введите через запятую числа, соответствующие начальной и конечной станциям'

    stations_indices = choose_stations

    start_station = stations[stations_indices[0]]
    finish_station = stations[stations_indices[1]]

    routes.push(Route.new(start_station, finish_station))
    puts "Новый маршрут с начальной станцией #{start_station.name} и конечной станцией #{finish_station.name}
    успешно создан"
    menu
  end

  def modify_object
    puts 'Для управлениями станциями в маршруте введите 1'
    puts 'Для назначения поезду маршрута введите 2'
    puts 'Для управления вагонами поезда введите 3'
    puts 'Для перемещения поезда по маршруту введите 4'
    puts 'Для возврата в главное меню - введите 0'

    cmd_number = gets.to_i
    return if cmd_number.zero?

    manage_stations if cmd_number == 1
    assign_route if cmd_number == 2
    manage_wagons if cmd_number == 3
    move_train if cmd_number == 4
  end

  def manage_stations
    puts 'Выберите маршрут для управлениями станциями из списка, представленного ниже'
    route = choose_route

    puts 'Для того, чтобы добавить станцию - введите 1, удалить - введите 2'
    cmd_number = gets.to_i

    add_station(route) if cmd_number == 1
    remove_station(route) if cmd_number == 2
  end

  def add_station(route)
    puts 'Выберите станцию, которую хотите добавить в выбранный маршрут'

    available_stations = stations.reject { |station| route.stations.include?(station) }

    available_stations.each_with_index { |station, index| puts "для добавления станции \"#{station.name}\" введите #{index + 1}" }
    station_index = gets.to_i - 1
    station = available_stations[station_index]

    is_done = route.add_station(station)
    puts "Станция #{station.name} успешно добавлена в маршрут" if is_done
  end

  def remove_station(route)
    puts 'Выберите станцию, которую хотите удалить'
    route.stations.each_with_index { |station, index| puts "для удаления станции \"#{station.name}\" введите #{index + 1}" }
    station_index = gets.to_i - 1
    station = route.stations[station_index]

    is_done = route.remove_station(station)
    puts "Станция #{station.name} успешно удалена из маршрута" if is_done
    menu
  end

  def assign_route
    puts 'Выберите поезд, для которого хотите определить маршрут из списка, представленного ниже'
    train = choose_train

    puts "Выберите маршрут, который хотите назначить для поезда №#{train.number}"
    route = choose_route

    train.route = route
    puts "Маршрут успешно назначен для поезда №#{train.number}"
  end

  def manage_wagons
    puts 'Выберите поезд, к которому хотите прицепить/отцепить вагон'
    train = choose_train

    puts 'Что хотите сделать с вагоном?'
    puts 'прицепить - введите 1'
    puts 'отцепить - введите 2'
    cmd_number = gets.to_i

    case cmd_number
    when 1
      case train.type
      when :passenger
        wagon = PassengerWagon.new
      when :cargo
        wagon = CargoWagon.new
      end

      is_done = train.add_wagon(wagon)
      puts "Вагон успешно прицеплен к поезду №#{train.number}" if is_done
    when 2
      is_done = train.remove_wagon
      puts "Вагон успешно отцеплен от поезда №#{train.number}" if is_done
    end

    menu
  end

  def move_train
    puts 'Выберите поезд, который хотите переместить по маршруту'
    train = choose_train

    puts 'Хотите переместить поезд на станцию вперед - введите 1, назад - введите 2'
    cmd_number = gets.to_i

    case cmd_number
    when 1
      is_done = train.move_forward
      puts "Поезд №#{train.number} успешно перемещен на станцию вперед" if is_done
    when 2
      is_done = train.move_back
      puts "Поезд №#{train.number} успешно перемещен на станцию назад" if is_done
    end

    menu
  end

  def show_stations_and_trains
    stations.each do |station|
      puts "Наименование станции: #{station.name}"

      trains_numbers = station.trains.map { |train| "№#{train.number}" }
      puts "Поезда на станции на текущий момент: #{trains_numbers.join(', ')}"
    end
  end

  def choose_stations
    stations.each_with_index { |station, index| puts "#{station.name} - введите #{index + 1}" }

    gets.encode('UTF-8', invalid: :replace).split(',').map { |cmd_number| cmd_number.to_i - 1 }
  end

  def choose_train
    trains.each_with_index do |train, index|
      puts "поезд №#{train.number} - введите #{index + 1}"
    end

    trains[gets.to_i - 1]
  end

  def choose_route
    routes_names = []

    routes.each do |route|
      finish_station_index = route.stations.length - 1
      routes_names.push("\"#{route.stations[0].name}-#{route.stations[finish_station_index].name}\"")
    end

    routes_names.each_with_index do |route_name, index|
      puts "#{route_name} - введите #{index + 1}"
    end

    route_index = gets.to_i - 1
    routes[route_index]
  end
end
