class Page
  def initialize(url)
    url_sections = url.split("/")
    @base_url = ""
    @base_url = url_sections[0] + "//" + url_sections[2]
    @path = ""
    url_sections.drop(3).each do |section|
      @path.concat("/" + section)
    end
  end
  
  def to_s
   "Page(base_url:" + @base_url.to_s + ",path:" + @path.to_s + ",html:" + @html.to_s + ")"
  end
end