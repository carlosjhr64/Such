require 'test/unit'
require 'such/version'

class TestVersion < Test::Unit::TestCase
  def test_vesion()
    assert_equal(Such::VERSION, '0.0.0')
  end
end
