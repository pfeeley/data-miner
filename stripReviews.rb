require 'rubygems'
require 'mysql'
require 'nokogiri'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")
db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])
stop_words = []
reviews = db.query("select * from reviews")
reviews.each_hash do |review|
  review_html = Nokogiri::HTML(review["review_text"])
  review_body = review_html.xpath("//div[@itemprop='reviewBody']").slice()
  puts review_body
end
