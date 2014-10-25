module Such
  module Widgets
    def self.gtk
      ObjectSpace.each_object(Class).
        select{|k| k < Gtk::Widget }.
        map{|k| k.name.sub('Gtk::','')}.
        each{|clss| Such.define(clss, "Gtk::#{clss}")}
    end
  end
end
