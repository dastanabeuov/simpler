require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @request.env['simpler.params'].merge!(@request.params)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers

      send(action)
      
      write_response

      @response.finish
    end

    private

    def set_custom_headers(headers)
      headers.each do |name, value|
        @response[name] = value
      end
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      @request.env['simpler.template'] = template
      if conform(template)
        @response['Content-Type'] = 'text/plain'
      View.new(@request.env).render(binding) 
    end

    def conform(template)
      template.class == Hash && (template.key?(:plain) || template.key(:inline))
    end

    def status(status_code)
      @response.status = status_code
    end    

    def params
      @request.env['simpler.params']
    end

  end
end
