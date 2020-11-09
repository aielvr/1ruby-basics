class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = :cargo
  end

  def add_wagon(wagon)
    super(wagon) if cargo_wagon?(wagon)
  end

  private

  # нет необходимости использовать данный метод через интерфейс  
  def cargo_wagon?(wagon)
    wagon.type == type 
  end
end