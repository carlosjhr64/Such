module Such
  module Thing
    INTOS = [:set_submenu, :pack_start, :append, :add] # TODO:GTK!?

    PARAMETERS = {}
    def self.configure(conf)
      conf.each{|k,v| PARAMETERS[k]=v}
    end

    def self.trace_method(obj, mthd, args)
      $stderr.puts "#{obj.class}##{mthd}(#{[*args].join(',')})"
    end

    def self.trace_signal(obj, signal)
      $stderr.puts "#{obj.class} links #{signal}"
    end

    def self.do_symbol(parameter, parameters)
      if PARAMETERS.has_key?(parameter)
        p = PARAMETERS[parameter]
        (parameter[-1]=='!')? parameters.unshift(*p) : parameters.unshift(p)
      else
        if parameter[-1]=='!'
          p = parameter[0..-2]
          parameters.unshift(p.downcase.to_sym)
          parameters.unshift(p.upcase.to_sym)
        else
          warn "Warning: Such::PARAMETERS[#{parameter}] not defined"
        end
      end
    end

    def self.do_parameters(parameters)
      container, arguments, methods, signals = nil, [], {}, []
      while parameter = parameters.shift
        case parameter
        when Symbol
          # Symbols are expected to translate to something else.
          Thing.do_symbol(parameter, parameters)
        when Array
          # Arrays are added to the Thing's arguments list.
          arguments += parameter
        when Hash
          # Hashes are expected to be a symbol list of methods on Thing with respective arguments.
          # It's possible to override a previously defined method with new arguments.
          parameter.each{|k,v| methods[k]=v}
        when String
          # Typically a signal: Thing#signal_connect(signal){|*emits| block.call(*emits)}
          signals.push(parameter)
        else
          # Assume it's a container
          container = parameter
        end
      end
      signals.uniq!
      return container, arguments, methods, signals
    end

    def self.which_method(container, methods=INTOS)
      methods.each{|mthd| return mthd if container.respond_to?(mthd)}
      raise "Don't know how to put into #{container.class}."
    end

    def self.into(obj, container=nil, mthd=nil, *args)
      if container
        mthd=Thing.which_method(container) unless mthd
        unless mthd.class==Symbol and container.respond_to?(mthd)
          raise "Need container & method. Got #{container.class}##{mthd}(#{obj.class}...)"
        end
        Thing.trace_method(container, mthd, [obj.class,*args]) if $VERBOSE
        container.method(mthd).call(obj, *args)
      else
        warn "Warning: Container for #{self.class} not given."
      end
    end

    def self.do_method(obj, mthd, *args)
      Thing.trace_method(obj, mthd, args) if $VERBOSE
      m = obj.method(mthd)
      begin
        m.call(*args)
      rescue ArgumentError, TypeError
        # Assume user meant to iterate. Note that the heuristic is not perfect.
        $stderr.puts "# Iterated Method #{mthd} ^^^" if $VERBOSE
        [*args].each{|arg| m.call(*arg)}
        if $!.class == ArgumentError and not m.arity == 1
          warn "Warning: Iterated method's arity not one."
        end
      end
    end

    def self.do_methods(obj, methods, container=nil)
      # If user does not specify how to add to container, assume default way.
      methods[:into]=Thing.which_method(container) if container and !methods.has_key?(:into)
      methods.each do |mthd, args|
        (mthd==:into)? Thing.into(obj, container, *args) :
                       Thing.do_method(obj, mthd, *args)
      end
    end

    def self.do_links(obj, signals, block)
      none = (signals.length==0)
      if block
        signals.push('clicked') if block and none # TODO: GTK!?
        signals.each do |signal|
          Thing.trace_signal(obj, signal) if $VERBOSE
          obj.signal_connect(signal){|*emits| block.call(*emits)} # TODO: GTK!?
        end
      elsif not none
        warn "Warning: No block given for #{signals.join(',')} on #{obj.class}."
      end
    end

    def self.do_config(obj, *parameters, &block)
      container, arguments, methods, signals = Thing.do_parameters(parameters)
      Thing.do_methods(obj, methods, container)
      Thing.do_links(obj, signals, block)
      warn "Warning: arguments not used in do_config(#{obj.class}...)." if arguments.length > 0
    end

    def initialize(*parameters, &block)
      container, arguments, methods, signals = Thing.do_parameters(parameters)
      super(*arguments)
      Thing.do_methods(self, methods, container)
      Thing.do_links(self, signals, block)
    end
  end
end
