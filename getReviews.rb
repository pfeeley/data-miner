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
index = 0

rows = items.num_rows
puts "Getting reviews for #{rows} items"

items.each_hash do |data|
  file = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{data["name"]}/#{data["iid"]}?_pgn=1"))
  pages = Integer(file.xpath("//div[@class='rvp-pgn']").text.split('\n')[0].split(' ')[3].delete "^0-9")

  puts data["iid"] + "|" + data["name"] + "|" + pages.to_s()
  pullReview(pages,data["iid"],data["name"])

  #after pulling 100 pages update the main index from the stop-press
  index++
  if index%100 == 0 do
    db.execute("insert into reviews (page, item, review_hash, review_text)" +
      " select page, item, review_hash, review_text from `reviews_stop-press`" +
      " where review_hash not in (select review_hash from reviews)")
  end
end

