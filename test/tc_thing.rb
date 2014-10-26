require 'test/unit'
require 'such/thing'

class TestBlankClass
  def initialize
  end
end

class TestBlankSubClass < TestBlankClass
  include Such::Thing
  def add(*stuff)
    # TODO
  end
  def signal_connect(string)
    # TODO
  end
end

class TestThing < Test::Unit::TestCase
  def test_parameters
    assert_equal(Such::Thing::PARAMETERS.class, Hash)
  end

  def test_new
    assert_nothing_thrown() do
      tc = TestBlankSubClass.new
    end
  end
end
