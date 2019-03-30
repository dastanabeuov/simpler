module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def path_apart(path)
        path.split('/').reject(&:empty?)
      end

      def params(env)
        path = env['PATH_INFO']
        request_path_apart = path_apart(path)
        router_path_apart = path_apart(@path)
        result_params(router_path_apart, request_path_apart)
      end
      
      def result_params(router_path_apart, request_path_apart)
        router_path_apart.zip(request_path_apart).each.with_object({}) do |(path_apart, request_apart), result|
          next unless path_apart.start_with?(':')
          result[path_apart.delete(':').to_sym] = request_apart
        end
      end

      def match?(method, path)
        @method == method && match_path?(path)
      end      

      def match_path?(path)
        router_path_apart  = path_apart(@path)
        request_path_apart = path_apart(path)

        valid?(router_path_apart, request_path_apart)
      end

      def valid?(router, request)
        return false if request.size != router.size
        router.zip(request).all? do |router_apart, request_apart|
          router_apart.start_with?(':') || router_apart == request_apart
        end
      end

    end
  end
end
