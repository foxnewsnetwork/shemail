require 'eventmachine'
require 'redis'
require 'hiredis'
require 'json'


class Femail < EventMachine::Protocols::SmtpServer
	@@redis = Redis.new :host => "67.202.50.113", :port => 6379, :driver => :hiredis
	
	def self.perform( key )
		puts @@redis.lrange( key, 0, -1	 )
		@@redis.del key
		puts "Email Queue Cleared"
	end # self.perform
end # Femail

EM.run do
	 # hit Control + C to stop
	Signal.trap("INT")  { EventMachine.stop }
	Signal.trap("TERM") { EventMachine.stop }
	puts "Starting Test Client"
	EventMachine.start_server("0.0.0.0", 3001, Femail)
	puts "Started"
	puts "Adding periodic timer"
	EventMachine::PeriodicTimer.new 5 do
		Femail.perform( "email-list" )
	end # new Timer
end # EM.run
