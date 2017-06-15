require_relative 'system/classes/Page.rb'

page = Page.new("http://oec.staging.t-r.io/solutions/d2d-express")
puts page.to_s