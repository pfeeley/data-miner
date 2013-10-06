require 'rubygems'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

mysql = Mysql.new(CONFIG["hostname"], CONFIG["username"], CONFIG["password"], CONFIG["database"])
items = mysql.query('select * from items')
items.each_hash do |item|
  puts item["iid"]
end
mysql.close;
