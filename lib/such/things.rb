module Such
  module Things
    def self.list(superklass)
      ObjectSpace.each_object(Class).select{|klass| klass < superklass}
    end

    def self.subclass(klass)
      Such.subclass(klass.name.sub(/^.*::/,'').to_sym, klass, include: Such::Thing)
    end

    def self.in(superklass)
      Things.list(superklass).each do |klass|
        begin
          Things.subclass(klass)
        rescue
          $stderr.puts "#{$!.class}:\t#{superklass}" if $VERBOSE
        end
      end
    end
  end
end
