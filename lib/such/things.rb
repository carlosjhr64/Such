module Such
  module Things
    def self.list(superklass)
      ObjectSpace.each_object(Class).select{|klass| klass < superklass}
    end

    def self.in(superklass)
      Things.list(superklass).each do |klass|
        begin
          Such.subclass(
            subklass:  klass.name.sub(/^.*::/,'').to_sym,
            klass:     klass,
            including: Such::Thing)
        rescue
          $stderr.puts "#{$!.class}:\t#{superklass}" if $VERBOSE
        end
      end
    end
  end
end
