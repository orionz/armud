class Room < ActiveRecord::Base
  has_many :mobiles
  has_many :items
end
