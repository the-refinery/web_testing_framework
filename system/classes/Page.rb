require 'colorize'
require 'nokogiri'
require 'open-uri'
require_relative "Hyperlink.rb"
class Page
  def initialize(url)
    @url = url
    url_sections = url.split("/")
    @protocol = "";
    @base_url = ""
    @path = ""
    @protocol = url_sections[0]
    @base_url = url_sections[2]
    url_sections.drop(3).each do |section|
      @path.concat("/" + section)
    end
    @html = open(@protocol + "//" + @base_url + @path).read
=begin
    @html = "<html>
      <title>This is the title</title>
      <body>
       <h1>Title Tag</h1>
       <h1>Another Title Tag</h1>
       <p><a>First Link</a> <a href='http://www.google.com/' target='nothing'>Second Link</a></p>
       <a href='../' target='_blank'>Third Link</a>
       <!--
        <a href='../../'>Fourth Link</a>
       -->
       <a href='http://www.facebook.com'>Fourth Link</a>
      </body>
     </html>"
=end
    @documentation = Nokogiri::HTML(@html)
    extract_links
  end
  
  def to_s
   str = "Page(protocol: " + @protocol + ",base_url:" + @base_url.to_s + ",path:" + @path.to_s + ",html:" + @html.to_s + ",hyperlinks: ["
   @hyperlinks.each do |link|
     str = str + link.to_s
     str += "," if (!link.equal?(@hyperlinks.last))
   end
   str += "])"
   str
  end
  
  def extract_links
    @hyperlinks = []
    links = @documentation.search('a')
    links.each do |link|
      @hyperlinks.push Hyperlink.new link.attr('href').to_s, link.attr('target').to_s
    end
  end
end