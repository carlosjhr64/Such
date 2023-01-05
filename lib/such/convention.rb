# Use this to validate your configuration against the given convention.
# It should be run as part of your tests,
# not necessarily in your application.
module Such
  module Convention
    module Refinements
      refine Object do
        def item_symbol?
          is_a?Symbol and match?(/^\w+[!?]?$/)
        end
        def item_boolean?
          [TrueClass,FalseClass].any?{is_a?_1}
        end
        def item_value?
          [String,Float,Integer].any?{is_a?_1}
        end
        def item?
          item_symbol? or item_value?
        end
        def items?
          item? or item_array? or item_hash?
        end
        def item_hash?
          is_a?Hash and all?{_1.item_symbol? and _2.items?}
        end
        def item_array?
          is_a?Array and all?{_1.items?}
        end
        def item_bang_array?
          is_a?Array and
          all?{_1.is_a?Symbol or _1.is_a?String or
               _1.item_array? or _1.item_hash?}
        end
        def item_explicit_array?
          is_a?Array and
          all?{_1.is_a?String or _1.item_array? or _1.item_hash?}
        end
      end
    end

    CAPS   = /^[A-Z_]+$/
    CAPS1  = /^[A-Z_]+!$/
    CAPS2  = /^[A-Z_]+[?]$/
    LOWER  = /^[a-z_]+$/
    LOWER1 = /^[a-z_]+!$/
    LOWER2 = /^[a-z_]+[?]$/
    WORD   = /^\w+$/
    WORD1  = /^\w+!$/
    WORD2  = /^\w+[?]$/

    using Refinements

    def self.validate_kv(k,v)
      raise   'unrecognized item symbol'    unless k.item_symbol?
      case k
      when LOWER  # abc
        raise 'unrecognized item hash'      unless v.item_hash? or
                                           (v.is_a?Symbol and LOWER.match?v)
      when CAPS   # ABC
        raise 'unrecognized item array'     unless v.item_array?
      when WORD   # Abc
        raise 'unrecognized item'           unless v.item?
      when LOWER1 # abc!
        raise 'unrecognized bang array'     unless v.item_bang_array?
      when CAPS1  # ABC!
        raise 'unrecognized explicit array' unless v.item_explicit_array?
      when WORD1  # Abc!
        raise 'unrecognized items'          unless v.items?
      when LOWER2 # abc?
        raise 'unrecognized boolean'        unless v.item_boolean?
      when CAPS2  # ABC?
        raise 'unrecognized nil|boolean'    unless v.nil? or v.item_boolean?
      when WORD2  # Abc?
        raise 'unrecognized nil|item'       unless v.nil? or v.item?
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
