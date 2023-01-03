# Use this to validate your configuration against the given convention.
# It should be run as part of your tests,
# not necessarily in your application.
module Such
  module Convention
    module Refinements
      refine Object do
        def key_symbol?
          is_a?Symbol and match?(/^\w+[!?]?$/)
        end
        def key_boolean?
          [TrueClass,FalseClass,NilClass].any?{is_a?_1}
        end
        def key_value?
          [String,Float,Integer].any?{is_a?_1}
        end
        def key_item?
          key_symbol? or key_value? or key_boolean?
        end
        def key_items?
          key_item? or key_array? or key_hash?
        end
        def key_hash?
          is_a?Hash and all?{_1.key_symbol? and _2.key_items?}
        end
        def key_array?
          (is_a?Array and all?{_1.key_items?})
        end
        def key_symbolic_array?
          (is_a?Array and all?{_1.is_a?String or _1.key_symbol?})
        end
        def key_explicit_array?
          (is_a?Array and all?{_1.is_a?String or _1.key_array? or _1.key_hash?})
        end
      end
    end
    using Refinements

    def self.validate_kv(k,v)
      raise 'unrecognized key' unless k.key_symbol?
      case k
      when /^[A-Z_]+$/ # CAPS
        raise 'unrecognized array' unless v.key_array?
      when /^[a-z_]+$/ # lower
        raise 'unrecognized hash' unless v.key_hash?
      when /^\w+$/ # Camel
        raise 'unrecognized item' unless v.key_item?
      when /^[A-Z_]+!$/ # CAPS!
        raise 'unrecognized explicit array' unless v.key_explicit_array?
      when /^[a-z_]+!$/ # lower!
        raise 'unrecognized symbolic array' unless v.key_symbolic_array?
      when /^\w+!$/ # Camel!
        raise 'unrecognized items' unless v.key_items?
      when /^\w+[?]$/ # Any?
        raise 'unrecognized boolean' unless v.key_boolean?
      else
        raise 'should not happen'
      end
    end

    def self.validate(config)
      raise 'expected hash' unless config.is_a?Hash
      errors = {}
      config.each do |k,v|
        begin
          validate_kv(k,v)
        rescue
          errors[k] = $!.message
        end
      end
      return errors.empty? ? nil : errors
    end
  end
end
