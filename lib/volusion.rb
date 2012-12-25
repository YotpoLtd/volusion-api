require "cgi"
require "uri"
require "net/https"

require "rubygems"
require "json"

require File.join(File.dirname(__FILE__), 'volusion', 'api')
require File.join(File.dirname(__FILE__), 'volusion', 'connection')

module Volusion
  VERSION = "0.0.7"
end
