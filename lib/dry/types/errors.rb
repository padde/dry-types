module Dry
  module Types
    extend Dry::Configurable

    setting :namespace, self

    class SchemaError < TypeError
      def initialize(key, value)
        super("#{value.inspect} (#{value.class}) has invalid type for :#{key}")
      end
    end

    SchemaKeyError = Class.new(KeyError)
    private_constant(:SchemaKeyError)

    class MissingKeyError < SchemaKeyError
      def initialize(key)
        super(":#{key} is missing in Hash input")
      end
    end

    ConstraintError = Class.new(TypeError) do
      attr_reader :result

      def initialize(result)
        @result = result
        if result.is_a?(String)
          super
        else
          super("#{result.input.inspect} violates constraints (#{failure_message})")
        end
      end

      def input
        result.input
      end

      def failure_message
        if result.respond_to?(:rule)
          rule = result.rule
          args = rule.predicate.args - [rule.predicate.args.last]
          "#{rule.predicate.id}(#{args.map(&:inspect).join(', ')}) failed"
        else
          result.inspect
        end
      end
    end
  end
end
