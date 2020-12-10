class PassengerWagon < Wagon
  attr_reader :seatQuantity, :seat_quantity, :vacant_seat_quantity

  def initialize(seat_quantity)
    @type = :passenger
    @seat_quantity = seat_quantity
    @vacant_seat_quantity = seat_quantity
  end

  def take_place
    # take a look how to decrease by one
    raise 'There is no vacant seat in the wagon' if vacant_seat_quantity === 0
    self.vacant_seat_quantity = vacant_seat_quantity - 1
  end

  def taken_seat_quantity
    seat_quantity - vacant_seat_quantity
  end

  private

  attr_writer :vacant_seat_quantity
end
