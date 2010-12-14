class Item < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  belongs_to :item  ## container
  belongs_to :room
  belongs_to :mobile ## mobile

  def to_s
    "a #{attr} #{name}"
  end

  def self.create_random!(args = {})
    create! args.merge( :name => names[rand(names.size)], :attr => attrs[rand(attrs.size)])
  end

  def self.names
    [ "ball", "rock", "nail" ]
  end


  def self.attrs
    [ "red", "small", "wet" ]
  end
end
