module Such
  module Things
    def self.list(super_class)
      ObjectSpace.each_object(Class).select{_1 < super_class}
    end

    def self.subclass(sub_class)
      Such.subclass(sub_class.name.sub(/^.*::/,'').to_sym, sub_class,
                    include: Such::Thing)
    end

    def self.in(super_class)
      Things.list(super_class).each do |sub_class|
        begin
          Things.subclass(sub_class)
        rescue
          $stderr.puts "#{$!.class}:\t#{super_class}" if $VERBOSE
        end
      end
    end
  end
end
