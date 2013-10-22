require 'rubygems'
require 'mysql'

#This method take the number of pages of reviews and pulls their review content
def pullReview(pages,iid,name)
  if pages > 1
    for i in 1..pages
      @db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])
      new_review = @db.prepare "insert into `reviews_stop-press` (page,item,review_hash,review_text) values (?,?,?,?)"
      puts "Getting content for page #{i}\n"
      doc = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{name}/#{iid}?_pgn=#{i}"))
      reviews = doc.xpath("//div[@id='Reviews']")
      reviews.each do |review|
        hash = Digest::SHA1.hexdigest review
        new_review.execute i, iid, hash.to_s(), review.to_s()
      end
      new_review.close
    end
  end
end

