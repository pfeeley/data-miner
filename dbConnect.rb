require 'rubygems'
require 'mysql'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")

#TODO: update all connection details to pull data from config file
#localhost,patridx2_miner,*,patridx2_mining


mysql = Mysql.new(CONFIG["hostname"], CONFIG["username"], CONFIG["password"], CONFIG["database"])
mysql.query('select DATABASE()')
mysql.close;
