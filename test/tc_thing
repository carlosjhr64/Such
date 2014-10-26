require 'test/unit'
require 'such/thing'
# Clear PARAMETERS of any defaults
Such::Thing::PARAMETERS.clear

################################
### Main Test Parent Classes ###
################################

class TestBlankClass
  attr_reader :packed, :added, :signals

  def initialize
    @packed = []
    @added = []
    @signals = []
  end

  def pack(x)
    @packed.push(x)
  end

  def add(*stuff)
    @added.push(*stuff)
  end

  def signal_connect(string)
    @signals.push(string)
  end
end

class TestOneClass < TestBlankClass
  attr_reader :b

  def initialize(b)
    super()
    @b = b
  end
end

class TestManyClass < TestBlankClass
  attr_reader :c

  def initialize(*c)
    super()
    @c = c
  end
end

#######################
### Test Subclasses ###
#######################

class TestBlankSubClass < TestBlankClass
  include Such::Thing
end

class TestOneSubClass < TestOneClass
  include Such::Thing
end

class TestManySubClass < TestManyClass
  include Such::Thing
end

class TestThing < Test::Unit::TestCase
  def test_parameters
    # I Haz PARAMETERS
    assert_nothing_raised() do
      p = Such::Thing::PARAMETERS
      assert_equal(p.class, Hash)
    end
  end

  def test_new_arity
    # Nothing raised with correct arity.
    assert_nothing_raised() do
      # Blank takes nothing
      TestBlankSubClass.new
      TestBlankSubClass.new []
      # One takes exactly one
      TestOneSubClass.new [1]
      # Many takes any
      TestManySubClass.new
      TestManySubClass.new []
      TestManySubClass.new [1]
      TestManySubClass.new [1,2,3]
    end

    # ArgumentError raised with incorrect arity
    assert_raise(ArgumentError) do
      TestBlankSubClass.new [1]
    end
    assert_raise(ArgumentError) do
      TestOneSubClass.new
    end
    assert_raise(ArgumentError) do
      TestOneSubClass.new []
    end
    assert_raise(ArgumentError) do
      TestOneSubClass.new [1,2,3]
    end
  end

  def test_initialize
    assert_nothing_raised() do
      blank = TestBlankSubClass.new
      assert_equal(blank.packed, [])
      blank.pack(1); blank.pack(2); blank.pack(4)
      assert_equal(blank.packed, [1,2,4])
    end
    assert_nothing_raised() do
      one = TestOneSubClass.new ['A']
      assert_equal(one.b, 'A')
    end
    assert_nothing_raised() do
      many0 = TestManySubClass.new
      many1 = TestManySubClass.new ['A']
      many3 = TestManySubClass.new ['x','y','z']
      many  = TestManySubClass.new ['A'],['x','y','z']
      assert_equal(many0.c, [])
      assert_equal(many1.c, ['A'])
      assert_equal(many3.c, ['x','y','z'])
      assert_equal(many.c,  ['A', 'x','y','z'])
    end
  end

  def test_methods
    assert_nothing_raised() do
      blank = TestBlankSubClass.new pack: 1
      one   = TestOneSubClass.new ['A'], pack: 2
      many  = TestManySubClass.new({pack: 3}, ['x','y','z'])

      assert_equal([1], blank.packed)

      assert_equal([2], one.packed)
      assert_equal('A', one.b)

      assert_equal([3], many.packed)
      assert_equal(['x','y','z'], many.c)

      # Quick overide test...
      blank2 = TestBlankSubClass.new({pack: 1}, {pack: 'a'})
      # Only pack('a') happens:
      assert_equal(['a'], blank2.packed)
    end
  end

  def test_link
    assert_nothing_raised() do
      blank = TestBlankSubClass.new 'event'
      blank2 = TestBlankSubClass.new('event1', 'event2'){ true }
      assert_equal(['event'], blank.signals)
      assert_equal(['event1', 'event2'], blank2.signals)
    end
  end

  def test_into
    assert_nothing_raised() do
      container = TestBlankSubClass.new
      # item should put itself into container
      item = TestBlankSubClass.new container
      assert_equal([item], container.added)
    end
  end

  def test_translation
    assert_nothing_raised() do
      p = Such::Thing::PARAMETERS
      p[:A] = [1,2,3]
      p[:a] = {pack: 'X'}
      p[:a!] = [:A,:a,'x']
      many = TestManySubClass.new(:a!){ true }
      assert_equal([1,2,3], many.c)
      assert_equal(['X'], many.packed)
      assert_equal(['x'], many.signals)
      p.clear # restore to clear
    end
  end
end
