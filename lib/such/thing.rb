module Such
  module Thing
    PARAMETERS = {}
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

      methods[:into]=[] if container and !methods.has_key?(:into)
      methods.each do |mthd, args|
        args.unshift(container) if mthd==:into and container
        trace_method(mthd, args) if $VERBOSE
        method(mthd).call(*args)
      end
      signals.keys.each do |signal|
        trace_signal(signal) if $VERBOSE
        link(signal, block)
      end
    end

    def link(signal, block)
      signal_connect(signal){|*emits| block.call(self, signal, *emits)}
    end

    def into(container, mthd=:add, *parameters)
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
