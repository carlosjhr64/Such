module Such
  def self.subclass(subklass:, klass:, including: nil)
    _ = const_set(subklass, Class.new(klass))
    _.include including if including
  end
end
