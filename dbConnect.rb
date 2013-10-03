require 'rubygems'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

mysql = Mysql.new('localhost', 'patridx2_miner', CONFIG["password"], 'patridx2_mining')
mysql.query('select DATABASE()')
mysql.close;
