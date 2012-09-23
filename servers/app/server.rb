require 'eventmachine'
require 'redis'
require 'hiredis'
require 'json'
class SheMail < EventMachine::Protocols::SmtpServer
	@@redis = Redis.new :host => "67.202.50.113", :port => 6379, :driver => :hiredis
	
	def initialize *args
		super
		@state_hash = { :data => "" }
	end # initialize
	
	def receive_line ln
		super ln
		# send_data "State: #{@state.class.to_s} is #{@state}\r\n"
	end # receive_line
	
	def process_mail_from sender
		super sender
		@state_hash[ :from ] = sender
	end # process_mail_from
	
	def process_rcpt_to rcpt
		super rcpt
		@state_hash[ :to ] = rcpt
	end # process_rcpt_to
	
	def process_data_line ln
		super ln
		@state_hash[ :data] += ln
		if ln == "."
			email_is_ready
		end # ln
	end # process_data_line
	
	private
	
		def email_is_ready
			@@redis.lpush "email-list", @state_hash.to_json 
		end # email_is_ready
		
end # SheMail

EM.run do
	 # hit Control + C to stop
	Signal.trap("INT")  { EventMachine.stop }
	Signal.trap("TERM") { EventMachine.stop }
	puts "Starting Test Server"
	EventMachine.start_server("0.0.0.0", 2999, SheMail)
end # EM.run
