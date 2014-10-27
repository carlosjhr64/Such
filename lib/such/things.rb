module Such
  module Things
    def self.list(clss=Gtk::Widget)
      ObjectSpace.each_object(Class).select{|k| k < clss}
    end

    def self.gtk_widget
      Things.list.each{|clss| Such.subclass(clss.name.sub('Gtk::',''))}
    end
  end
end
