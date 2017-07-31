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
      $stderr.puts code if $VERBOSE
      raise $!
    end
  end
end
