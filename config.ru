require_relative 'middleware/logger'
require_relative 'config/environment'

#run Simpler.application
use ApplicationLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application