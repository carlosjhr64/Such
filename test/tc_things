require 'test/unit'
require 'such/things'

module A
  class X
  end
  class X1 < X
  end
  class X2 < X
  end
  class X3 < X
  end
end

module Gtk
  class Widget
  end
  class A < Widget
  end
  class B < Widget
  end
  class C < Widget
  end
end

module Such
  LIST = []
  def self.subclass(clss)
    raise 'WUT?' unless ['A','B','C'].include?(clss)
    LIST.push(clss)
  end
end

class TestThings < Test::Unit::TestCase
  def test_list
    assert_equal(Such::Things.list(A::X).sort, ['X1','X2','X3'])
    assert_equal(Such::Things.list.sort, ['A','B','C'])
  end

  def test_gtk_widget
    assert_nothing_raised() do
      Such::Things.gtk_widget
    end
    assert_equal(Such::LIST.sort, ['A','B','C'])
  end
end
