module Such
  def self.subclass(name, klass, **kw, &block)
    subklass = const_set(name, Class.new(klass))
    kw.each{|method, args| subklass.send(method, *args)}
    subklass.class_eval(&block) if block
    return subklass
  end
end
