require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/sha1'
require 'mysql'
require 'yaml'
require 'get'

CONFIG = YAML.load_file("./config.yml")

db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])
items = db.query("select * from items")

rows = items.num_rows
puts "Getting reviews for #{rows} items"

items.each_hash do |data|
  file = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{data["name"]}/#{data["iid"]}?_pgn=1"))
  pages = Integer(file.xpath("//div[@class='rvp-pgn']").text.split('\n')[0].split(' ')[3].delete "^0-9")

  puts data["iid"] + "|" + data["name"] + "|" + pages.to_s()
  pullReview(pages,data["iid"],data["name"])
end
