module Such
  module Part
    def initialize(*parameters, &block)
      super(*parameters)
      self.class.plugs.each do |plg|
        if /^(?<sym>[^\W_]+)_(?<cls>[^\W_]+)$/=~plg
          plg, sym, cls = method("#{plg}="), "#{sym}!".to_sym, Object.const_get("Such::#{cls}")
          plg.call cls.new(self, sym, &block)
        end
      end
    end

    def message(*parameters)
      self.class.plugs.each{|plg| method(plg).call.message(*parameters)}
    end

    def method_missing(plug,*args) # assuming a plug
      super unless args.length==0 and plug=~/^[^\W_]+_[^\W_]+$/
      obj = nil
      self.class.plugs.each do |plg|
        plug = method(plg).call
        if plug.is_a? Such::Part
          break if obj = plug.method(plg).call
        end
      end
      return obj
    end
  end
end
