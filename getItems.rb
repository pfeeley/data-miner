require 'rubygems'
require 'nokogiri'
require 'yaml'
require 'mysql'
require 'open-uri'

CONFIG = YAML.load_file("./config.yml")

db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])
categories = db.query('select * from categories')

categories.each do |cat|
  pages = Nokogiri::HTML(open("http://search.reviews.ebay.com/?fgtp=1&ucat=#{cat}&uqt=r"))
  total_pages = Integer(pages.xpath("//div[@id='paging']/table/tr/td[1]").text.split(' ').last.gsub(/[^0-9]/,''))
  for i in 1..total_pages do
    page_content = Nokogiri::HTML(open("http://search.reviews.ebay.com/?fgtp=#{i}&ucat=#{cat}&uqt=r"))
    items = page_content.xpath("//div[@class='title']")
    puts items
  end
end

#TODO: add db check

#TODO: save discovered items
