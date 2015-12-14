module Such
  def self.subclass(clss, sprclss="Gtk::#{clss}", body='include Such::Thing')
    code = <<-CODE
class #{clss} < #{sprclss}
  #{body}
end
    CODE
    begin
      eval code
    rescue Exception
      warn code
      raise $!
    end
  end
end
