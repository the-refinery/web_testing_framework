require 'open-uri'
class Page
  def initialize(url)
    url_sections = url.split("/")
    @protocol = "";
    @base_url = ""
    @path = ""
    @protocol = url_sections[0]
    @base_url = url_sections[2]
    url_sections.drop(3).each do |section|
      @path.concat("/" + section)
    end
    #@html = open(@protocol + "//" + @base_url + @path).read
    @html = "
     <html>
      <title>This is the title</title>
      <body>
       <p><a>First Link</a> <a href='http://www.google.com/' onclick='nothing'>Second Link</a></p>
       <a href='../'>Third Link</a>
       <!--
        <a href='../../'>Fourth Link</a>
       -->
       <a href='http://www.facebook.com'>Fourth Link</a>
      </body>
     </html>"
  end
  
  def to_s
   "Page(protocol: " + @protocol + ",base_url:" + @base_url.to_s + ",path:" + @path.to_s + ",html:" + @html.to_s + ")"
  end
end