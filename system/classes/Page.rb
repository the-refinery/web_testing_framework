class Page
  def initialize(url)
    @base_url = "base"
    @path = "path"
    @html="html"
  end
  def to_s
   "Page(base_url:" + @base_url + ",path:" + @path + ",html:" + @html + ")"
  end
end