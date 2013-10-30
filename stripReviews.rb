require 'rubygems'
require 'mysql'
require 'nokogiri'
require 'yaml'

CONFIG = YAML.load_file("./config.yml")
db = Mysql.new(CONFIG['hostname'],CONFIG['username'],CONFIG['password'],CONFIG['database'])


