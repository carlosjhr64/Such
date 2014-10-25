module Such
  def self.subclass(clss, sprclss="Gtk::#{clss}", body='include Such::Thing')
    eval <<-CODE
    class #{clss} < #{sprclss}
      #{body}
    end
    CODE
  end
end
