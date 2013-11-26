require 'rubygems'

def parseReviews(star_rating, review_body)
  review_body = review_body.to_s.split(" ")
  review_body.each do |word|
    puts word
    #TODO: check if the word already exists in the index, add if new
    #TODO: cycle through words and calculate score
  end
end
