require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = {} 
      parse_www_encoded_form(req.body)         if req.body
      parse_www_encoded_form(req.query_string) if req.query_string
      @params.merge!(route_params)             if route_params
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      decoded_url = URI::decode_www_form(www_encoded_form)
      decoded_url.each do |key, value|
        nested_keys = parse_key(key)
        @params.deep_merge!(construct_nested_hash(nested_keys, value))
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end

    def construct_nested_hash(keys, value)
      return value if keys.empty?
      {keys.shift => construct_nested_hash(keys, value)}
    end
  end
end
