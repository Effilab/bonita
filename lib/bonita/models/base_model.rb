# frozen_string_literal: true

module Bonita
  class BaseModel
    class << self
      attr_reader :attributes

      def attribute(name)
        @attributes ||= []

        return if @attributes.include? name

        @attributes << name
        send(:attr_accessor, name)
      end
    end

    def initialize(params = {})
      self.class.attributes.each do |key|
        instance_variable_set("@#{key}", params[key])
      end
    end

    def ==(other)
      self.class == other.class &&
        instance_variables == other.instance_variables &&
        instance_variables.none? { |ivar| instance_variable_get(ivar) != other.instance_variable_get(ivar) }
    end

    def to_hash
      self.class.attributes.each.with_object({}) do |attribute, hash|
        hash[attribute] = instance_variable_get("@#{attribute}")
      end
    end

    def inspect
      values = instance_variables.map { |name| [name, instance_variable_get(name)] }.to_h
      "<#{self.class.name} #{values}>"
    end
  end
end
