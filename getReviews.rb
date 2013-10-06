require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/sha1'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

#TODO: pull information from database and generate URL automatically

name = "Motorola-Droid-X-8GB-Black-Verizon-Smartphone-"
file = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{name}/102650543?_pgn=1"))
pages = Integer(file.xpath("//div[@class='rvp-pgn']").text.split('\n')[0].split(' ')[3].delete "^0-9")
puts "Getting content for page 1"
reviews = file.xpath("//div[@id='Reviews']").first

#TODO: refactor single vs multiple reviews

begin
  db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])

  if pages > 1
    for i in 2..pages
      new_review = db.prepare "insert into reviews (page, review_hash) values (?,?)"
      puts "Getting content for page #{i}\n"
      doc = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{name}/102650543?_pgn=#{i}"))
      reviews = doc.xpath("//div[@id='Reviews']").first
      hash = Digest::SHA1.hexdigest reviews
      puts hash
      new_review.execute i, hash
      new_review.close
    end
  end

ensure
  db.close
end


#TODO: extract review data from pulled content
#TODO: tokenize reviews and save to database index


