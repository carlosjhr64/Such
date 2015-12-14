module Such
  module Things
    def self.list(klss)
      ObjectSpace.each_object(Class).select{|k| k < klss}
    end

    def self.in(klass)
      Things.list(klass).each do |clss|
        begin
          Such.subclass(clss.name.sub(/^.*::/, ''))
        rescue Exception
          warn "#{$!.class}:\t#{clss}"
        end
      end
    end

    def self.gtk_widget
      Things.in(Gtk::Widget)
    end

    def self.tk_tile
      Things.in(Tk::Tile)
    end
  end
end
