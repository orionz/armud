class Item < ActiveRecord::Base
  has_many :items
  belongs_to :item
  belongs_to :room
  belongs_to :mobile
end
