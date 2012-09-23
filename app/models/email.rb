require 'eventmachine'
require 'redis'
require 'hiredis'

class Email < ActiveRecord::Base
	@@redis = Redis.new :host => "67.202.50.113", :port => 6379, :driver => :hiredis
	
	puts "Initializing Email Model"
	EventMachine::PeriodicTimer.new 5 do
		puts "Attempting redis retrieval"
		Email.dump_from_redis
		puts "Retrieval complete"
	end # new Timer
	
	attr_accessible :contents
	
	def self.dump_from_redis
		emails = @@redis.lrange "email-list", 0, -1
		puts "detected emails: #{emails.count}" if emails.count
		emails.each do |email|
			Email.create :contents => email
		end # each email
		@@redis.del "email-list"
	end # dump_from_redis
end # Email
