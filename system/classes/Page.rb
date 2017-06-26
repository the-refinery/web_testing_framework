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
    in_comment = false
    parsing_tag = false
    href = ""
    parsing_href = false
    target = ""
    parsing_target = false
    authorized_to_parse = false
    puts has_tag? "a"
    if (has_tag? "a")
      @html.length.times do |i|
        if (beginning_of_comment? i, @html)
          in_comment = true
        elsif (end_of_comment? i, @html)
          in_comment = false
        end
        if (!in_comment && !parsing_tag && @html[i - 1] == '<' && @html[i] == 'a' && (@html[i + 1] == ' ' || @html[i + 1] == '>'))
          parsing_tag = true
          puts "Parsing Tag: " + parsing_tag.to_s + " " + i.to_s
        end
        if (parsing_tag && @html[i - 3] == 'h' && @html[i - 2] == 'r' && @html[i - 1] == 'e' && @html[i] == 'f')
          parsing_href = true
        elsif (parsing_tag && @html[i - 5] == 't' && @html[i - 4] == 'a' && @html[i - 3] == 'r' && @html[i - 2] == 'g' && @html[i - 1] == 'e' && @html[i] == 't')
          parsing_target = true
        end
        if (parsing_tag && parsing_href && authorized_to_parse && @html[i] != '"')
          href = href + @html[i]
        elsif (parsing_tag && parsing_href && authorized_to_parse && @html[i] == '"')
          parsing_href = false
          authorize_to_parse = false
        end
        if (parsing_tag && parsing_href && !authorized_to_parse && @html[i] == '"')
          authorized_to_parse = true
        end
        if (parsing_tag && parsing_target && authorized_to_parse && @html[i] != '"')
          target = target + @html[i]
        elsif (parsing_tag && parsing_target && authorized_to_parse && @html[i] == '"')
          parsing_target = false
          authorize_to_parse = false
        end
        if (parsing_tag && parsing_target && !authorized_to_parse && @html[i] == '"')
          authorized_to_parse = true
        end
        if (parsing_tag && @html[i] == '>')
          parsing_tag = false
          puts "Parsing Tag: " + parsing_tag.to_s + " " + i.to_s
          @hyperlinks.push(Hyperlink.new(href, target))
          href = ""
          target = ""
        end
      end
    end
  end
  
  def has_tag? tag
    in_comment = false
    checking_for_tag = false
    tag_check_index = 0
    # iterate through html characters
    @html.length.times do |i|
      # if entering or exiting a comment
      if (beginning_of_comment? i, @html)
        in_comment = true
      elsif (end_of_comment? i, @html)
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
  
  private
  
  def beginning_of_comment? i, html
    i >= 3 && html[i - 3] == '<' && html[i - 2] == '!' && html[i - 1] == '-' && html[i] == '-'
  end
  
  def end_of_comment? i, html
    i >= 4 && html[i - 2] == '-' && html[i - 1] == '-' && html[i] == '>'
  end
end