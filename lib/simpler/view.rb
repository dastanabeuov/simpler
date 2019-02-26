require_relative 'view/html_renderer'
require_relative 'view/plain_text_renderer'
require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    RENDER_TYPES = {
      plain: PlainTextRenderer,
      html: HTMLRenderer
    }.freeze

    DEFAULT_RENDER_TYPE = RENDER_TYPES[:html]

    def initialize(env)
      @env = env
    end

    def render(binding)
      #template = File.read(template_path)
      return RENDER_TYPES[render_type.downcase.to_sym].new(@env, render_type_options).render if render_type
      
      DEFAULT_RENDER_TYPE.new(@env).render
      #ERB.new(template).result(binding)
    end

    private

    def render_type
      @env['simpler.render_type']
    end

    def render_type_options
      @env['simpler.render_type_options'] if render_type
    end    

=begin
    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
=end

  end
end
