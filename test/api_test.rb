require 'test_helper'

class ApiTest < Test::Unit::TestCase

  def setup
    @store_url = "http://example.volusion.com"
    @configuration = {:store_url => @store_url, :username  => 'volusion@example.com', :encrypted_password   => '12345'}
    @volusion_api = Volusion::Api.new @configuration
  end

  def test_prepare_select_data_for_array
    assert 'p.ProductName, p.ProductUrl', @volusion_api.send(:prepare_select_fields, ['p.ProductName', 'p.ProductUrl'])
  end

  def test_prepare_select_data_for_string
    assert 'p.ProductName, p.ProductUrl', @volusion_api.send(:prepare_select_fields, 'p.ProductName, p.ProductUrl')
  end

  def test_prepare_select_data_should_fail_for_invalid_input_type
    assert_raise Volusion::Error::InvalidSelectArgument do
      @volusion_api.send(:prepare_select_fields, 5)
    end
  end

  def test_raises_exception_for_invalid_export_object
    assert_raise NoMethodError do
      @volusion_api.get_friends :invalid_object
    end
  end

  def test_ping_for_valid_credentials
    assert_nothing_raised do
      @volusion_api.ping
    end
  end

  def test_ping_raises_exception_for_invalid_credentials
    wrong_configuration = {:store_url => "http://www.invalidstoreurl.com", :username  => 'invalid_username', :encrypted_password   => 'invalid_encrypted_password'}
    wrong_cred_api = Volusion::Api.new wrong_configuration
    assert_raise Volusion::Error::InvalidCredentials do
      wrong_cred_api.ping
    end
  end

  def test_default_select_fields_are_all_fields
    response = @volusion_api.get_products
    assert_equal 72, response['Products'].count
  end

  def test_should_raise_error_for_multiple_conditions
    assert_raise Volusion::Error::NotSupportedError do
      response = @volusion_api.get_products({:conditions => {"field1" => "value1", "field2" => "value2"}})
    end
  end

  def test_get_objects_should_raise_exception_on_invalid_object
    assert_raise Volusion::Error::InvalidExportObject do
      @volusion_api.send(:get_objects, "Nothing")
    end
  end

  def test_get_custom_orders_returns_false_if_customization_missed
    api = Volusion::Api.new({
      store_url: 'http://www.invalidstoreurl.com',
      username: 'invalid_username',
      encrypted_password: 'invalid_encrypted_password'
    })

    assert_equal false, api.get_custom_orders
  end

  def test_get_custom_orders_returns_orders_from_custom_api
    orders = @volusion_api.get_custom_orders['Orders']

    assert_not_nil orders
    assert_equal 6, orders.length
  end

end
