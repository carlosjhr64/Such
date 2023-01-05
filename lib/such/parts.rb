module Such
  module Parts
    ### Such::Parts ###
    # Signature:
    #   Such::Parts.make(part\Symbol, thing\Such::Thing, plugs\Array(Symbol)) \
    #   (Such::Thing+Such::Part)
    # The name of the Such::Part sub-class will be part.
    # It will be a sub-class of thing(a sub-class of Such::Thing).
    # The Array of symbols, plugs, will be accessors to other connected Such::Part's.
    # Each plug must match:
    #   /^<Part config key!>_<Name of connected sub-classed super-class>$/
    # Note that these plugs are `attr_accessor`s,.
    # Exemplar:
    #   Component0#initialize(...,&block_given)
    #     ...
    #     part_obj.key_Component1 = Component1.new(:key!,&block_given)
    #     ...
    # Note that all connected components share the same block_given:
    #   block_given(part\Such::Part, *w, signal\String)
    # It gets called when the part receives its assigned activation signal,
    # like "clicked" for a Button.
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
