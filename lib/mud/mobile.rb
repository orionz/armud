class Mobile < ActiveRecord::Base
  belongs_to :room
  has_many :items, :dependent => :destroy

  def con
    MUD::OpenConnections[id]
  end

  def others
    room.mobiles.reject { |m| m == self }
  end

  def write(line)
    con.write(line) if con
  end

  def command(cmd, arg)
    case cmd
    when "look" then do_look
    when "smile" then do_smile
    when "summon" then do_summon
    when "get" then do_get(arg)
    when "drop" then do_drop
    when "help" then write "You're going to need it."
    else write "Command unknown '#{cmd}'."
    end
  end

  def do_look
    write room.name.upcase
    write "    #{room.desc}"
    write "[----]"
    write "There are #{room.items.size} items and #{others.size} mobiles."
    others.each { |m| write "#{m} is here" }
    room.items.each { |i| write "#{i} is here" }
  end 

  def do_smile
    write "You smile."
    others.each { |p| p.write "#{self} smiles." }
  end

  def do_summon
    i = Item.create_random! :room => room
    write "You summon #{i}."
    others.each { |p| p.write "#{self} summons #{i}." }
  end

  def do_get(name)
    i = room.items.detect { |i| i.name == name }
    if i
      write "You get #{i}."
      others.each { |o| "#{self} gets #{i}." }
      take i
    else
      write "You see no #{name} here."
    end
  end

  def do_drop
    write "You drop everything."
    others.each { |o| o.write "#{self} drops everything." }
    items.each { |i| room.take i }
  end

  def take(item)
    item.item   = nil
    item.room   = nil
    item.mobile = self
    item.save!
  end

  def to_s
    name
  end
end
