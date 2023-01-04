module Such
  module Parts
    def self.make(part, thing, *plugs)
      unless thing < Such::Thing and [part,*plugs].all?{_1.is_a? Symbol}
        raise "Expected Such::Parts.make(Symbol part, " +
              "Class thing < Such::Thing, *Symbol plugs)"
      end
      plugs.each do |plug|
        if /^[^\W_]+_(?<super_class>[^\W_]+)$/=~plug
          next unless $VERBOSE
          unless Object.const_defined?("Such::#{super_class}")
            $stderr.puts "Warning: Such::#{super_class} not defined yet."
          end
        else
          raise "Plugs must have the form key_class: #{plug}"
        end
      end
      sub_class = Such.subclass(part, thing,
                               include: Such::Part, attr_accessor: plugs)
      sub_class.singleton_class.class_eval{ define_method(:plugs){plugs} }
      return sub_class
    end
  end
end
