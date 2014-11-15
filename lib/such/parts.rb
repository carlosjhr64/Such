module Such
  module Parts
    def self.make(part, thing, *plugs)
      raise "Superclass(#{thing}) must be a Such::Thing" unless Object.const_get(thing) < Such::Thing
      plugs.each{|plug|
        raise "Plugs must have the form key_class: #{plug}" unless plug=~/^[^\W_]+_[^\W_]+$/
      }
      Such.subclass part, thing,  <<-EOT
        attr_accessor :#{plugs.join(', :')}
        def self.plugs
          [:#{plugs.join(', :')}]
        end
        include Such::Part
      EOT
    end
  end
end
