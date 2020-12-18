module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validators
      @validators ||= []
    end

    def validate(attr_name, validation_type, optional_arg = nil)
      var_name = "@#{attr_name}".to_sym
      validators.push(type: validation_type, var: var_name, args: optional_arg)
    end
  end

  module InstanceMethods
    def presence_validation(value, optional_arg)
      raise "Attribute value shouldn't be nil or empty string" if value.nil? || value.empty? || value.strip.empty?
    end

    def type_validation(value, class_name)
      raise "Attribute value doesn't belong to #{class_name} class" if value.class != class_name
    end

    def format_validation(value, regexp)
      raise "Attribute value doesn't match the regexp" if value.match(regexp).nil?
    end

    def validate!
      self.class.validators.each do |validator|
        value = instance_variable_get(validator[:var])

        self.send("#{validator[:type]}_validation", value, validator[:args])
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
