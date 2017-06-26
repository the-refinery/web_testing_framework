require 'open-uri'
require 'nokogiri'

site = 'http://oec.staging.t-r.io'
html = open(site).read
document = Nokogiri::HTML(html)
puts document.to_s