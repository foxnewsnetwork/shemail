require 'redis'
require 'hiredis'

class RedisTest
	@@redis = Redis.new( :host => "67.202.50.113", :port => 6379, :driver => :hiredis)
	
	def self.get_from_redis
		@@redis.lrange "list-simple-test", 0, -1
	end # get_from_redis
	
	def self.save_to_redis( stuff )
		@@redis.lpush( "list-simple-test", stuff ) if stuff.is_a?(String)
	end # save_to_redis
	
end # RedisTest

ARGV.each do |a|
	RedisTest.save_to_redis a
end # each a


RedisTest.get_from_redis.each do |k|
	puts "#{k}"
end # each k
