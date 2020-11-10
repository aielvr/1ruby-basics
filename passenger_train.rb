class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = :passenger
  end

  def add_wagon(wagon)
    super(wagon) if suitable_wagon?(wagon)
  end
end
