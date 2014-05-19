require 'fake_web'

module FakeWeb
  FakeWeb.allow_net_connect = false

  valid_ping_url = "http://example.volusion.com/net/WebService.aspx?EDI_Name=Generic%5CProducts&SELECT_Columns=*&WHERE_Column=p.ProductID&WHERE_Value=NULL&Login=volusion@example.com&EncryptedPassword=12345"
  invalid_ping_url = "http://www.invalidstoreurl.com/net/WebService.aspx?EDI_Name=Generic%5CProducts&SELECT_Columns=*&WHERE_Column=p.ProductID&WHERE_Value=NULL&Login=invalid_username&EncryptedPassword=invalid_encrypted_password"
  all_fields_products = "http://example.volusion.com/net/WebService.aspx?EDI_Name=Generic%5CProducts&SELECT_Columns=*&Login=volusion@example.com&EncryptedPassword=12345"
  invalid_custom_orders_url = 'http://www.invalidstoreurl.com/v/orders.asp?Login=invalid_username&EncryptedPassword=invalid_encrypted_password'
  valid_custom_orders_url = 'http://example.volusion.com/v/orders.asp?Login=volusion@example.com&EncryptedPassword=12345'

  invalid_request_volusion_result = ""
  xml_empty_result = File.read(File.dirname(__FILE__) + "/fixtures/ping.xml")
  xml_products_all_fields = File.read(File.dirname(__FILE__) + "/fixtures/products.xml")
  xml_custom_orders = File.read(File.dirname(__FILE__) + "/fixtures/custom_orders.xml")

  FakeWeb.register_uri(:get, valid_ping_url, :body => xml_empty_result, :status => [200, 'OK'])
  FakeWeb.register_uri(:get, invalid_ping_url, :body => invalid_request_volusion_result, :status => [200, 'OK'])
  FakeWeb.register_uri(:get, all_fields_products, :body => xml_products_all_fields, :status => [200, 'OK'])
  FakeWeb.register_uri(:get, invalid_custom_orders_url, :body => xml_empty_result, :status => [404, 'Not Found'])
  FakeWeb.register_uri(:get, valid_custom_orders_url, :body => xml_custom_orders, :status => [200, 'OK'])

end