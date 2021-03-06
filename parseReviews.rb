require 'rubygems'
require 'mysql'

def parseReviews(star_rating, review_body, item, hash)
  db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])

  review_body = review_body.to_s.split(" ")

  #prepare database operations
  records_query = db.prepare("select * from `word_index` where word = ?")
  new_word = db.prepare("insert into `word_index` (`word`, `count`, `score`) values (?,1,?)")
  update_word   = db.prepare("update `word_index` set count = ?, score = ? where word = ?")

  #parse each word in the review
  review_body.each do |word|
    record = records_query.execute(word).fetch
    if record.nil?
      new_word.execute(word, star_rating.to_s.to_f)
    else
      new_count = record[1].to_f + 1.to_f
      new_score = ((record[1].to_f*record[2].to_f)+star_rating.to_s.to_f)/(new_count)
      update_word.execute(new_count, new_score, word)
    end
  end
  db.close
end
