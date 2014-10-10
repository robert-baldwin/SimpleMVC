require 'json'
require 'webrick'

module Bonus 
  class Flash 
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        @flash = JSON.parse!(cookie.value) if cookie.name == '_rails_lite_flash'
      end
      @flash ||= {}
    end

    def now
      @now ||= {}
    end

    def [](key)
      now[key] || @flash[key]
    end

    def []=(key, val)
      @flash[key] = val
    end
    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_flash', @flash.to_json)
    end
  end

  class CSRFToken
    attr_reader :token

    def initialize
      @token = self.generate_csrf_token
    end

    def self.generate_csrf_token
      SecureRandom::urlsafe_base64(16)
    end
  end
end
