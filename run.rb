require 'open-uri'
require 'nokogiri'
require_relative 'system/classes/Hyperlink.rb'

class Site
  def initialize(domain)
    @domain = domain
    @hyperlinks = []
  end
end

site = 'http://oec.staging.t-r.io'
html = open(site).read
document = Nokogiri::HTML(html)