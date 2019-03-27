require 'logger'

class ApplicationLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(format_message(env))
    [status, headers, body]
  end

  def format_message(env)
    if env['simpler.controller']
      @logger.info("\nRequest: #{env['REQUEST_METHOD']} " +
                   "#{env["simpler.controller"].request.env['REQUEST_PATH']}" +
                   "?#{env['QUERY_STRING']}\n" +
                   "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" +
                   "Parameters: #{env["simpler.controller"].request.params}\n" +
                   "Response: #{env["simpler.controller"].response.status} " +
                   "[#{env["simpler.controller"].response.header['Content-Type']}] " +
                   "#{env['simpler.template_path']}")
    else
      @logger.info("\nRequest: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}\n" +
                   "Handler: none (resource does not exist)\n" +
                   "Parameters: #{env['QUERY_STRING']}")
    end
  end
end