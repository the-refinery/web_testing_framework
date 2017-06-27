require 'open-uri'
require 'colorize'
require 'mechanize'
require_relative 'system/classes/Hyperlink.rb'

class Site
  def initialize(domain)
    @domain = domain
    @hyperlinks = []
    @links_analyzed = []
  end
  
  def domain
    @domain
  end
  
  def extract_links
    @hyperlinks = []
    @agent = Mechanize.new
    puts "Extracting Links"
    puts ""
    puts @domain.cyan
    get_new_links @domain
  end
  
  private
  
  def get_new_links site_page
    @agent.get(site_page)
    links = @agent.page.search('a')
    links.each do |link|
      href = link.attr('href')
      href = @domain + href if href[0] == '/'
      new_link = Hyperlink.new href, link.attr('target').to_s
      if (!contains_hyperlink? new_link)
        @hyperlinks.push new_link
        @links_analyzed.push false
      end
    end
    sort_hyperlinks
    check_as_analyzed site_page
    @hyperlinks.length.times do |i|
      print @hyperlinks[i].href + " -- "
      if (@links_analyzed[i])
        print @links_analyzed[i].to_s.green
      else
        print @links_analyzed[i].to_s.red
      end
      print "\n"
    end
  end
  
  def contains_hyperlink? link
    @hyperlinks.each do |hyperlink|
      return true if link.equal? hyperlink
    end
    false
  end
  
  def sort_hyperlinks
    @hyperlinks.length.times do |i|
      ((i + 1)...@hyperlinks.length).each do |j|
        if (@hyperlinks[j].href < @hyperlinks[i].href)
          temp_hyperlink = @hyperlinks[i]
          temp_analyzed = @links_analyzed[i]
          @hyperlinks[i] = @hyperlinks[j]
          @hyperlinks[j] = temp_hyperlink
          @links_analyzed[i] = @links_analyzed[j]
          @links_analyzed[j] = temp_analyzed
        end
      end
    end
  end
  
  def check_as_analyzed page
    @hyperlinks.length.times do |i|
      if (@hyperlinks[i].href == page || @hyperlinks[i].href == page + '/')
        @links_analyzed[i] = true
        break
      end
    end
  end
end

#domain = "t-r.io"
#subdomains = ["oec.staging"]
domain = "duckbrand.com"
subdomains = [""]
extra_security = false
site_names = []
subdomains.each do |d|
  site_name = "http"
  site_name = site_name + "s" if extra_security
  site_name = site_name + "://"
  site_name = site_name + d + "." if d.length > 0
  site_name = site_name + domain
  site_names.push site_name
end
sites = []
site_names.each do |site_name|
  sites.push Site.new site_name
end
sites.each do |site|
  site.extract_links
end