module Volusion
  class Api

    def initialize(configuration={})
      @connection = Connection.new(configuration)
    end

    def connection
      @connection
    end

    def store_url=(store_url)
      @connection.store_url = store_url
    end

    def username=(username)
      @connection.username = username
    end

    def encrypted_password(encrypted_password)
      @connection.encrypted_password = encrypted_password
    end

    def method_missing(method, args=nil)
      super unless (objects  = method.to_s.match /get_(orders|products|customers)$/)
      get_objects objects[1].capitalize, args
    end

    def ping
      return get_products ({:conditions => {"p.ProductID" => "NULL"}})
    end

    def get_custom_orders(params = {})
      data = @connection.get('/v/orders.asp', params)
      return data unless data

      # fix orders to have products as an array
      orders = {}
      product_attributes = %w(ProductID ProductCode)
      data['Orders'].each do |order|
        id = order['OrderID']
        orders[id] ||= order.select { |key, value| !product_attributes.include?(key) }
        (orders[id]['OrderDetails'] ||= []) << order.select { |key, value| product_attributes.include?(key) }
      end

      { 'Orders' => orders.values }
    end

    private

    def get_objects(objects, args=nil)
      raise Error::InvalidExportObject unless ["Orders", "Products", "Customers"].include? objects
      params = {"EDI_Name" => "Generic\\#{objects}"}
      params["SELECT_Columns"] = "*"
      if args
        params["SELECT_Columns"] = prepare_select_fields(args[:select_fields]) if args[:select_fields]

        if (conditions = args[:conditions])
          #cuurently volusion api supports only one where condition
          raise Error::NotSupportedError if conditions.class != Hash or conditions.size != 1
          params["WHERE_Column"] = conditions.keys.first
          params["WHERE_Value"] = conditions.values.first
        end
      end
      @connection.get(nil, params)
    end

    def prepare_select_fields(fields)
        if fields.class == Array
          return fields.join(',')
        elsif fields.class == String
          return fields
        else
          raise Error::InvalidSelectArgument
        end
    end
  end
end
