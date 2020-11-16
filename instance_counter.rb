module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instance_counter ||= 0
    end

    def increment_instance_counter
      @instance_counter = instances.next
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.increment_instance_counter
    end
  end
end
