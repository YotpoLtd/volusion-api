require 'test_helper'

class ConnectionTest < Test::Unit::TestCase

  def setup
    @store_url = "http://example.volusion.com"
    @connection = Volusion::Connection.new({:store_url => @store_url, :username  => 'volusion@example.com', :encrypted_password   => '12345'})
  end

  def test_hash_to_params
    result = @connection.hash_to_params({:a => 1, :b => 2})
    assert_equal "a=1&b=2", result
  end

  def test_hash_to_params_empty
    result = @connection.hash_to_params({})
    assert_equal nil, result
  end

  def test_hash_to_params_nil
    result = @connection.hash_to_params(nil)
    assert_equal nil, result
  end

end
