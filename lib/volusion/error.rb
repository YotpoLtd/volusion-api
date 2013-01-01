module Volusion
  module Error
    class InvalidCredentials      < StandardError; end
    class InvalidExportObject     < StandardError; end
    class InvalidSelectArgument   < StandardError; end
    class NotSupportedError       < StandardError; end
    class ConnectionError         < StandardError; end
  end
end