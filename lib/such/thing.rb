module Such
  module Thing
    PARAMETERS = {}
    def self.configure(conf)
      conf.each{|k,v| PARAMETERS[k]=v}
    end

    def initialize(*parameters, &block)
      container, arguments, methods, signals = nil, [], {}, {}
      while parameter = parameters.shift
        case parameter
        when Symbol
          # Symbols are expected to translate to something else.
          if PARAMETERS.has_key?(parameter)
            p = PARAMETERS[parameter]
            (parameter[-1]=='!')? parameters.unshift(*p) : parameters.unshift(p)
          else
            warn "Warning: Such::PARAMETERS[#{parameter}] not defined"
          end
        when Array
          # Arrays are added to the Thing's arguments list.
          arguments += parameter
        when Hash
          # Hashes are expected to be a symbol list of methods on Thing with respective arguments.
          parameter.each do |k,v|
            # It's possible to override a previously defined method with new arguments.
            methods[k]=v
          end
        when String
          # Typically a signal: Thing#signal_connect(signal){|*emits| block.call(*emits)}
          signals[parameter] = true
        else
          # Assume it's a container
          container = parameter
        end
      end

      super(*arguments)

      # If user does not specify how to add to container, assume default way.
      methods[:into]=[] if container and !methods.has_key?(:into)
      methods.each do |mthd, args|
        trace_method(mthd, args) if $VERBOSE
        if mthd==:into
          if container
            into(container, *args)
          else
            warn "Warning: Container for #{self.class} not given."
          end
        else
          m = method(mthd)
          if m.arity == 1
            # Assume user knows arity is one and means to iterate.
            [*args].each{|arg| m.call(arg)}
          else
            m.call(*args)
          end
        end
      end

      signals.keys.each do |signal|
        trace_signal(signal) if $VERBOSE
        link(signal, block)
      end
    end

    def link(signal, block)
      signal_connect(signal){|*emits| block.call(*emits)}
    end

    def into(container, mthd=:add, *parameters)
      raise "Need container & method" unless mthd.class==Symbol and container.respond_to?(mthd)
      container.method(mthd).call(self, *parameters)
    end

    def trace_method(mthd, args)
      $stderr.puts "#{self.class.name}##{mthd}(#{args})"
    end

    def trace_signal(signal)
      $stderr.puts "#{self.class.name} links #{signal}"
    end
  end
end
