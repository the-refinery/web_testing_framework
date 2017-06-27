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
      puts link.attr('href')
    end
  end
  
  def contains_hyperlink? link
    @hyperlinks.each do |hyperlink|
      return true if link.equal? hyperlink
    end
    false
  end
end

site = Site.new 'http://oec.staging.t-r.io'
site.extract_links