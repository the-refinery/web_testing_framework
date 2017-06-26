require_relative 'system/classes/Page.rb'

page = Page.new("http://oec.staging.t-r.io/")
puts page.to_s
puts "Extracting Links"