module Such
  module Part
    PLUG_PATTERN = /^(?<sym>[^\W_]+)_(?<cls>[^\W_]+)$/

    def initialize(*parameters, &block)
      super(*parameters)
      self.class.plugs.each do |plg|
        if md = PLUG_PATTERN.match(plg)
          plg,sym,cls = "#{plg}=".to_sym,
                        "#{md[:sym]}!".to_sym,
                        Object.const_get("Such::#{md[:cls]}")
          # self.<plg> = Such::<cls>.new(self, :<sym>!, &block)
          public_send plg, cls.new(self, sym, &block)
        end
      end
    end

    # Each part\Such::Part can invoke `message` on each of its connected part,
    # and so on...
    # Any part can override its `message` method to act as a terminal node or
    # modify its relay behavior.
    def message(*parameters)
      self.class.plugs.each{|plg| public_send(plg).message(*parameters) }
    end

    # Maybe a plug down the plugged things responds?
    # This is a search through the connections which
    # returns the first(non-nil) response.
    def method_missing(maybe,*args)
      super unless args.length==0 and PLUG_PATTERN.match?(maybe)
      self.class.plugs.each do |plug|
        thing = public_send(plug)
        if thing.is_a? Such::Part
          if obj = thing.public_send(maybe)
            return obj
          end
        end
      end
      return nil
    end
  end
end
