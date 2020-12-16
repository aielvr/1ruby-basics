module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validators
      @validators ||= []
    end

    def presence_validation_var
      @presence_validation_var ||= []
    end

    def regexp_validation_var
      @regexp_validation_var ||= []
    end

    def type_validation_var
      @type_validation_var ||= []
    end

    def validate(attr_name, validation_type, optional_arg = nil)
      var_name = "@#{attr_name}".to_sym

      case validation_type

      when :presence
        define_method("presence_validation_#{attr_name}") do
          value = instance_variable_get(var_name)
          raise "Attribute value shouldn't be nil or empty string" if value.nil? || value.empty? || value.strip.empty?
        end

        presence_validation_var.push(attr_name)

      when :format
        define_method("regexp_validation_#{attr_name}") do
          regexp = optional_arg
          value = instance_variable_get(var_name)
          raise "Attribute value doesn't match the regexp" if regexp.match(value).nil?
        end
        regexp_validation_var.push(attr_name)

      when :type
        define_method("type_validation_#{attr_name}") do
          value = instance_variable_get(var_name)
          class_name = optional_arg
          raise "Attribute value doesn't belong to #{class_name} class" if value.class != class_name
        end

        type_validation_var.push(attr_name)
      else raise 'Wrong argument is received'
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.type_validation_var.each do |var|
        eval("type_validation_#{var}")
      end

      self.class.presence_validation_var.each do |var|
        eval("presence_validation_#{var}")
      end

      self.class.regexp_validation_var.each do |var|
        eval("regexp_validation_#{var}")
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
