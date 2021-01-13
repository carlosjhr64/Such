module Such
  def self.subclass(klass:, superklass:, including: Such::Thing)
    _ = const_set(klass, Class.new(superklass))
    _.include including if including
  end
end
