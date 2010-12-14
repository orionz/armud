class Room < ActiveRecord::Base
  has_many :mobiles
  has_many :items

  def take(item)
    item.item   = nil
    item.room   = self
    item.mobile = nil
    item.save!
  end
end
