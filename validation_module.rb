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

      case validation_type

      when :presence
        validators.push({ type: :presence, var: var_name })

      when :format
        validators.push({ type: :format, var: var_name, args: optional_arg })

      when :type
        validators.push({ type: :type, var: var_name, args: optional_arg })

      else raise 'Wrong argument is received'
      end
    end
  end

  module InstanceMethods
    def presence_validation(var)
      value = instance_variable_get(var)
      raise "Attribute value shouldn't be nil or empty string" if value.nil? || value.empty? || value.strip.empty?
    end

    def type_validation(var, class_name)
      value = instance_variable_get(var)
      raise "Attribute value doesn't belong to #{class_name} class" if value.class != class_name 
    end

    def format_validation(var, regexp)
      value = instance_variable_get(var)
      raise "Attribute value doesn't match the regexp" if value.match(regexp).nil?
    end

    def validate!
      self.class.validators.each do |validator|
        case validator[:type]
        when :presence
          presence_validation validator[:var]
        when :type
          type_validation validator[:var], validator[:args]
        when :format
          format_validation validator[:var], validator[:args]
        end
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
