module Such
  module Things
    def self.list(clss=Gtk::Widget)
      ObjectSpace.each_object(Class).
        select{|k| k < clss }.
        map{|k| k.name.sub(/^.*::/,'')}
    end

    def self.gtk_widget
      Things.list.each{|clss| Such.subclass(clss)}
    end
  end
end
