require "eventmachine"

@local_spec = { 
	:domain=>"localhost",
	:host=>'127.0.0.1',
	:port => 3000 ,
	:starttls=>false, # use ssl
	:from=>"shemail@localhost",
	:to=> [ 'kumakise@localhost' ] ,
	:header=> { "Subject" => "Some header", "CC" => "ajsdlkfjasdf" } ,
	:body=> "Some testing content" + "\r\n.\r\n"
} # local_spec

@gmail_spec =  {
	:domain=>"gmail.com",
	:host=>'74.125.224.214',
	:port => 25 ,
	:starttls=>false, # use ssl
	:from=>"shemail@doitfaggot.com",
	:to=> [ 'kumakise@doitfaggot.com' ] ,
	:header=> { "Subject" => "Some header", "CC" => "ajsdlkfjasdf" } ,
	:body=> "Some testing content" + "\r\n.\r\n"
} 


EM.run do
	 # hit Control + C to stop
	Signal.trap("INT")  { EventMachine.stop }
	Signal.trap("TERM") { EventMachine.stop }
	
	email = EM::Protocols::SmtpClient.send( @gmail_spec )
	email.callback do
		puts 'Email sent!'
		EventMachine.stop
	end # callback
	email.errback do |e| 	
		puts "Email failed! #{e}" 
		EventMachine.stop
	end
end # EM.run
