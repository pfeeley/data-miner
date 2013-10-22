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
  update = db.prepare "insert into items_stop-press (iid,display_name,name) values (?,?,?)"
  for i in 1..total_pages do
    page_content = Nokogiri::HTML(open("http://search.reviews.ebay.com/?fgtp=#{i}&ucat=#{cat}&uqt=r"))
    items = page_content.xpath("//div[@class='title']")
    items.each do |item|
     iid = item.to_s().split('/ctg/')[1].split('/')[1].split('#')[0]
     name = item.to_s().split('/ctg/')[1].split('/')[0]
     display = item.text
     update.execute iid, display, name
    end
    puts "completed page #{i}"
  end
  update.close
end

#db.execute('insert into items (iid, display_name, name) select distinct iid, display_name, name from items_stop-press')
