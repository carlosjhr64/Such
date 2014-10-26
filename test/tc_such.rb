require 'test/unit'
require 'such/such'

class SomeClass
  def initialize(v)
    @value=v
  end
end

module SomeModule
  def value
    @value
  end
end

class TestSuch < Test::Unit::TestCase
  def test_subclass
    assert_nothing_thrown() do
      Such.subclass('AClass', 'SomeClass', 'include SomeModule')
      this_instance = Such::AClass.new('This Value')
      assert_equal(this_instance.value, 'This Value')
    end
  end
end
