require 'rubygems'
require 'test/unit'
require 'volusion'
require 'fakeweb'


class Test::Unit::TestCase


  def load_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.xml")
  end

  include FakeWeb

end

