module Volusion
  class Connection

    def initialize(configuration)
      @configuration = configuration
    end

    def store_url=(store_url)
      @configuration[:store_url] = store_url
    end

    def username=(username)
      @configuration[:username] = username
    end

    def encrypted_password=(encrypted_password)
      @configuration[:encrypted_password] = encrypted_password
    end

    def get(path, params=nil)
      request(:get, path, nil, params)
    end

    def post(path)
      request(:post, path)
    end

    def put(path)
      request(:put, path)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, body = nil, params = {})

      url = "#{@configuration[:store_url]}/net/WebService.aspx"

      login_cred = {"Login" => @configuration[:username], "EncryptedPassword" => @configuration[:encrypted_password]}
      params = params.nil? ? login_cred : params.merge(login_cred)

      param_string = hash_to_params(params) unless params.nil? || params.empty?

      unless (param_string.nil? || param_string.empty?)
        uri = URI.parse(URI.escape("#{url}?#{param_string}"))
      else
        uri = URI.parse(URI.escape(url))
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https') ? true : false

      request = case method
                  when :get then
                    Net::HTTP::Get.new(uri.request_uri)
                  when :post then
                    Net::HTTP::Post.new(uri.request_uri)
                  when :put then
                    Net::HTTP::Put.new(uri.request_uri)
                  when :delete then
                    Net::HTTP::Delete.new(uri.request_uri)
                end

      request.add_field 'Accept', 'application/xml'
      request.add_field 'Content-Type', 'application/xml'

      response = http.request(request)

      return case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          raise Error::InvalidCredentials if response.body.empty?
          xml_result = MultiXml.parse(response.body)
          return fix_hash xml_result
        else
         false
        end
    end

    def hash_to_params(hash)
      return nil if hash.nil? || hash.empty?
      return hash.map {|pair| pair.join("=")}.join("&")
    end

    private

    #make sure products/orders/customers is an array of hashes even if only one result
    def fix_hash(xml_result)
      return nil if xml_result.nil? or (xml_result.class != Hash) or xml_result["xmldata"].nil?
      hash = xml_result["xmldata"]

      key = hash.keys.first
      hash[key] = to_arr_if_needed hash[key]

      #fix same issue for orderDetails if more then one product for order
      if key == "Orders"
        hash["Orders"].each do |order|
          if order["OrderDetails"]
            order["OrderDetails"] = to_arr_if_needed order["OrderDetails"]
          end
        end
      end
      return hash
    end

    def to_arr_if_needed(obj)
      return (obj.class == Array) ? obj : [obj]
    end
  end

end
