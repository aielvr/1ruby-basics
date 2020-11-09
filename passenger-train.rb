class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = :passenger
  end

  def add_wagon(wagon)
    super(wagon) if passenger_wagon?(wagon)
  end

  private

  # нет необходимости использовать данный метод через интерфейс
  def passenger_wagon?(wagon)
    wagon.type == type
  end
end