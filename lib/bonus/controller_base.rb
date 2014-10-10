require_relative '../phase6/controller_base'
require_relative './flash'

module Bonus 
  class ControllerBase < Phase6::ControllerBase
    def redirect_to(url)
      super
      flash.store_flash(req)
    end

    def render_content(content, type)
      super
      flash.store_flash(req)
    end

    # method exposing a `Flash` object
    def flash 
      @flash ||= Flash.new(req) 
    end
  end
end
