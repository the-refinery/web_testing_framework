require 'net/http'
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
  end
  
  def to_s
   "Page(protocol: " + @protocol + ",base_url:" + @base_url.to_s + ",path:" + @path.to_s + ",html:" + @html.to_s + ")"
  end
end