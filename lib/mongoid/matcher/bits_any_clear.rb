module Mongoid
  module Matcher

    # @api private
    module BitsAnyClear
      module_function def matches?(exists, value, condition)
        case value
        when BSON::Binary
          value = value.data.split('').map { |n| '%02x' % n.ord }.join.to_i(16)
        end
        case condition
          when Array
          # array of bits
            condition.any? do |c|
              value & (1<<c) == 0
            end
        when BSON::Binary
          int_cond = condition.data.split('').map { |n| '%02x' % n.ord }.join.to_i(16)
          (value & int_cond == 0) || (!(value & int_cond == int_cond) && (value & int_cond > 0))
        when Integer
          # todo: simplify
          (value & condition == 0) || (!(value & condition == condition) && (value & condition > 0))
        else
          raise Errors::InvalidQuery, "Unknown $bitsAllClear argument #{condition}"
        end
      end
    end
  end
end
