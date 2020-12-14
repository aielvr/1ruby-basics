require_relative 'produced_by_module'

class Wagon
  include ProducedBy

  attr_reader :type
end
