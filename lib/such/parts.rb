module Such
  module Parts
    def self.make(part, thing, *plugs)
      raise "Such::#{thing} not defined." unless Object.const_defined?("Such::#{thing}")
      plugs.each do |plug|
        if /^[^\W_]+_(?<klass>[^\W_]+)$/=~plug
          next unless $VERBOSE
          unless Object.const_defined?("Such::#{klass}")
            $stderr.puts "Warning: Such::#{klass} not defined yet."
          end
        else
          raise "Plugs must have the form key_class: #{plug}"
        end
      end
      subklass = Such.subclass(part, thing, include: Such::Part, attr_accessor: plugs)
      subklass.singleton_class.class_eval{ define_method(:plugs){plugs} }
      return subklass
    end
  end
end
