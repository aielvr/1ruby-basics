module ProducedBy
  def self.included(base)
    # base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    attr_accessor :produced_by
  end
end
