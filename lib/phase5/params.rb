require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params 
      parse_www_encoded_form(req.body)         if req.body
      parse_www_encoded_form(req.query_string) if req.query_string
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
      key_values = URI::decode_www_form(www_encoded_form)
      key_values.each do |key, value|
        nested_keys = parse_key(key)
        construct_and_merge_nested_hash(nested_keys, value)
        # @params.deep_merge!(rconstruct_nested_hash(nested_keys, value))
        # @params.deep_merge!(iconstruct_nested_hash(nested_keys, value))
      end
    end
    
    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end

    # construct bottom-up -- requires #deep_merge!
    def rconstruct_nested_hash(keys, value)
      return value if keys.empty?
      { keys.shift => rconstruct_nested_hash(keys, value) }
    end

    # construct bottom-up -- requires #deep_merge!
    def iconstruct_nested_hash(keys, value)
      nested_hash = { keys.pop => value }

      until keys.empty?
        key = keys.pop
        nested_hash = { key => nested_hash }
      end

      nested_hash
    end

    # construct top-down -- requires direct access to @params
    def construct_and_merge_nested_hash(keys, value)
      scope = @params

      until keys.empty?
        key = keys.shift
        scope[key] ||= (keys.empty? ? value : {})
        scope = scope[key]
      end
    end
  end
end
