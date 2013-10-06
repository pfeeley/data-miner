require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/sha1'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

#TODO: pull information from database and generate URL automatically
@db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])

@name = "Motorola-Droid-X-8GB-Black-Verizon-Smartphone-"
@iid = "102650543"

file = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{@name}/#{@iid}?_pgn=1"))
pages = Integer(file.xpath("//div[@class='rvp-pgn']").text.split('\n')[0].split(' ')[3].delete "^0-9")

#This method take the number of pages of reviews and pulls their review content
def pullReview(pages)
  if pages > 1
    for i in 1..pages
      new_review = @db.prepare "insert into reviews (page, review_hash) values (?,?)"
      puts "Getting content for page #{i}\n"
      doc = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{@name}/#{@iid}?_pgn=#{i}"))
      reviews = doc.xpath("//div[@id='Reviews']").first
      hash = Digest::SHA1.hexdigest reviews
      puts hash
      #new_review.execute i, hash
      new_review.close
    end
  end
end

pullReview(pages)

#TODO: extract review data from pulled content
#TODO: tokenize reviews and save to database index


