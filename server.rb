$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib/")

require 'eventmachine'
require 'mud'

module MUD
  OpenConnections = {}
  Dirty = {}

  module Connection
    def post_init
      send_data("Login: ")
    end

    def prompt
      send_data "h:12 v:10> "
      Dirty[self] = false
    end

    def write line
      send_data "\n" unless Dirty[self]
      puts "[#{@player.name}] #{line}"
      send_data "#{line}\n"
      Dirty[self] = true
    end

    def clean_dirty_connections
      Dirty.delete_if do |con,tf|
        con.prompt
        true
      end
    end

    def receive_data(data)
      if @player
        @player.reload
        Dirty[self] = true
        ### ' SaY hello WORld ' --> 'say', 'hello WORld'
        match = data.strip.match(/(\w*)\s*(.*)/)
        @player.command match[1].downcase, match[2]
        clean_dirty_connections
      else
        name = data.strip.capitalize
        @player = Mobile.find_by_name name
        if @player
          send_data "Welcome back!\n"
        else
          send_data "Creating new player #{name}\n"
          @player = Mobile.create! :name => name
        end
        Dirty[self] = true
        prompt
        ## we need to save which connection goes with which player
        OpenConnections[@player.id] = self
      end
    end
  end
end

EventMachine::run do
  EventMachine::start_server "0.0.0.0", MUD::Port, MUD::Connection
  puts "Started #{MUD::Brand} Server. To connect use 'telnet 0.0.0.0 #{MUD::Port}'"
end

