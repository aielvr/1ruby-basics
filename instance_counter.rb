module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      instance_counter
    end

    protected

    attr_accessor :instance_counter
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instance_counter += 1
    end
  end
end
