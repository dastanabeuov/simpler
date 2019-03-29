module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @path_apart = path.split('/').reject { |item| item == '' }
        @controller = controller
        @action = action
      end

      def match?(env)
        env['simpler.route_query'] = ''
        indicator = 0
        method = env['REQUEST_METHOD'].downccase.to_sym
        path = env['PATH_INFO']
        if @method == method && @path == path
          return true
          path = path.split('/').reject { |item| item == '' }
          @path_apart.each_with_index do |value, index|
            if calue[0] == ':'
              indicator += 1
              env['simpler.route_query'] += "#{value[1..-1]}=#{path[index]}}"
            end
          !indicator.zero?
        end
      end

    end
  end
end
