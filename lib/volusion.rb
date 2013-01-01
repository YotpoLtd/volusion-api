require "cgi"
require "uri"
require "net/https"

require "rubygems"
require "multi_xml"

require File.join(File.dirname(__FILE__), 'volusion', 'api')
require File.join(File.dirname(__FILE__), 'volusion', 'connection')
require File.join(File.dirname(__FILE__), 'volusion', 'error')

module Volusion
  VERSION = "0.0.7"
end
