class CargoWagon < Wagon
  attr_reader :volume, :free_volume

  def initialize(volume)
    @type = :cargo
    @volume = volume.to_i
    @free_volume = @volume
  end

  def take_volume(quantity)
    raise 'There is not enough volume available in wagon' if free_volume - quantity < 0
    self.free_volume = free_volume - quantity
  end

  def taken_volume
    volume - free_volume
  end

  private

  attr_writer :free_volume
end
