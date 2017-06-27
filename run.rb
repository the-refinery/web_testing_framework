require 'open-uri'
require 'colorize'
require 'mechanize'
require_relative 'system/classes/Hyperlink.rb'

class Site
  def initialize(domain)
    @domain = domain
    @hyperlinks = [
     Hyperlink.new('../', '_target'),
     Hyperlink.new('../../', '_window')
    ]
  end
  
  def domain
    @domain
  end
  
  def extract_links
    @hyperlinks = []
    @agent = Mechanize.new
    puts "Extracting Links"
    puts ""
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
      end
    end
    sort_hyperlinks
    @hyperlinks.each do |link|
      puts link.href
    end
  end
  
  def contains_hyperlink? link
    @hyperlinks.each do |hyperlink|
      return true if link.equal? hyperlink
    end
    false
  end
  
  def sort_hyperlinks
    (0...@hyperlinks.length).each do |i|
      ((i + 1)...@hyperlinks.length).each do |j|
        if (@hyperlinks[j].href < @hyperlinks[i].href)
          temp = @hyperlinks[i]
          @hyperlinks[i] = @hyperlinks[j]
          @hyperlinks[j] = temp
        end
      end
    end
  end
end

domain = "t-r.io"
subdomains = ["oec.staging"]
extra_security = false
site_names = []
subdomains.each do |d|
  site_name = "http"
  site_name = site_name + "s" if extra_security
  site_name = site_name + "://" + d + "."
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