$LOAD_PATH.unshift File.dirname(__FILE__)

require 'active_support/all'
require 'active_record'

require 'mud/room'
require 'mud/mobile'
require 'mud/item'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database  => File.dirname(__FILE__) + "/../database.sqlite"

