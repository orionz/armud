class Mobile < ActiveRecord::Base
  belongs_to :room
  has_many :items
end
