require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      erb_template = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
      html_page = ERB.new(erb_template).result(binding)
      render_content(html_page, 'text/html')
    end
  end
end
