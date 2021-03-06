$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib/"

require 'mud'

ActiveRecord::Migration.create_table :mobiles do |t|
  t.text :name, :null => false
  t.integer :room_id, :default => 1, :null => false
  t.integer :hp, :default => 10
  t.integer :vit, :default => 12
  t.timestamps
end

ActiveRecord::Migration.create_table :items do |t|
  t.text :name, :null => false
  t.text :attr, :null => false
  t.integer :room_id
  t.integer :item_id
  t.integer :mobile_id
  t.timestamps
end

ActiveRecord::Migration.create_table :rooms do |t|
  t.text :name, :null => false
  t.text :desc, :null => false
  t.timestamps
end

room1 = Room.create! :name => "the arctic", :desc => "It is very cold here"
Item.create! :name => "ball", :attr => "red", :room => room1
Mobile.create! :name => "Joe", :room => room1
