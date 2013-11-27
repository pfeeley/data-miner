require 'rubygems'
require 'mysql'

CONFIG = YAML.load_file("./config.yml")

def parseReviews(star_rating, review_body, item, hash)
  db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])

  review_body = review_body.to_s.split(" ")
  review_body.each do |word|
    records = db.query("select * from `word_index` where word = '#{word}'")
    if records.num_rows == 0
      db.query("insert into `word_index` (word, count, score) values ('#{word}',1,#{star_rating})")
    else
      records.each_hash do |record|
        new_count = record["count"].to_f + 1.0
        db.query("update `word_index` set count = #{new_count}, score = #{((record["count"].to_f*record["score"].to_f)+star_rating.to_s.to_f)/(new_count)} where word = '#{word}'")
      end
    end 
  end
  db.close
end
