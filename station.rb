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
