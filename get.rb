#This method take the number of pages of reviews and pulls their review content
def pullReview(pages,iid,name)
  if pages > 1
    for i in 1..pages
#TODO: create new database connection for reviews
      #new_review = @db.prepare "insert into reviews (page, review_hash) values (?,?)"
      puts "Getting content for page #{i}\n"
      doc = Nokogiri::HTML(open("http://www.ebay.com/rvw/#{name}/#{iid}?_pgn=#{i}"))
      reviews = doc.xpath("//div[@id='Reviews']").first
      hash = Digest::SHA1.hexdigest reviews
      puts hash
      #new_review.execute i, hash
      #new_review.close
    end
  end
end

