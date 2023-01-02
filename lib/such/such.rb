module Such
  def self.subclass(name, super_class, **including, &block)
    # See documentation for Class#new
    sub_class = const_set(name, Class.new(super_class))
    # To be able to say like:
    #   include Such::Thing
    #   attr_accessor :attribute2, :attribute2
    including.each{|these, mods| sub_class.public_send(these, *mods)}
    # And to explicitly define methods in the subclass:
    sub_class.class_eval(&block) if block
    return sub_class
  end
end
