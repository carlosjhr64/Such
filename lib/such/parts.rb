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
