require 'rubygems'
require 'mysql'
require 'nokogiri'
require 'yaml'
require './parseReviews'

CONFIG = YAML.load_file("./config.yml")
db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])

#load stopword list into memory
stop_words = IO.readlines("./stopwords.txt")
puts "stopwords loaded..."

#prepare update query
update_parsed = db.prepare("update reviews set parsed = 'Y' where item = ? and review_hash = ?")

#load all existing reviews that have not been parsed yet 
reviews = db.query("select * from reviews where parsed != 'Y'")

#parse the reviews
reviews.each_hash do |review|
  puts "processing item #{review["item"]} review #{review["review_hash"]}"
  review_html = Nokogiri::HTML(review["review_text"])
  review_rating = review_html.xpath("//span[@itemprop='reviewRating']/@content")
  review_body = review_html.xpath("//div[@itemprop='reviewBody']").to_s.downcase.gsub(/(<.*?>|[^a-z ]|\b{1}#{stop_words.map{|x| x.chomp}.join("\\b|\\b")}\b)/i,"")
  parseReviews(review_rating, review_body, review["item"], review["review_hash"])
  update_parsed.execute(review["item"], review["review_hash"])
end

db.close if db
