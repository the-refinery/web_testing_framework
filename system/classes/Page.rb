require 'open-uri'
require_relative "Hyperlink.rb"
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
   str = "Page(protocol: " + @protocol + ",base_url:" + @base_url.to_s + ",path:" + @path.to_s + ",html:" + @html.to_s + ",hyperlinks: ["
   @hyperlinks.each do |link|
     str = str + link.to_s
     str += "," if (!link.equal?(@hyperlinks.last))
   end
   str += "])"
   str
  end
  
  def has_tag? tag
    in_comment = false
    checking_for_tag = false
    tag_check_index = 0
    # iterate through html characters
    @html.length.times do |i|
      # if entering or exiting a comment
      if (i >= 3 && @html[i - 3] == '<' && @html[i - 2] == '!' && @html[i - 1] == '-' && @html[i] == '-')
        in_comment = true
      elsif (i >= 4 && @html[i - 2] == '-' && @html[i - 1] == '-' && @html[i] == '>')
        in_comment = false
      end
      # check for initialization of tag
      if (i > 0 && !in_comment && !checking_for_tag && @html[i - 1] == '<' && @html[i] == tag[0])
        checking_for_tag = true
        tag_check_index = 1;
      end
      if (checking_for_tag && tag_check_index < tag.length && @html[i] == tag[tag_check_index])
        tag_check_index = tag_check_index + 1
      elsif (tag_check_index == tag.length && (@html[i] == ' ' || @html[i] == '>'))
        return true
      end
    end
    false
  end
end