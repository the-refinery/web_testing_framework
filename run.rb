require 'open-uri'
require 'nokogiri'
require_relative 'system/classes/Hyperlink.rb'

class Site
  def initialize(domain)
    @domain = domain
    @hyperlinks = []
  end
end

site = Site.new 'http://oec.staging.t-r.io'