require 'rubygems'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

mysql = Mysql.new(CONFIG["hostname"], CONFIG["username"], CONFIG["password"], CONFIG["database"])
mysql.query('select DATABASE()')
mysql.close;
