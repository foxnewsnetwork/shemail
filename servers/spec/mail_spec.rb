require 'mail'

mail = Mail.new do
	from "someone@localhost"
	to "kumakise@gmail.com"
	subject "Testing sending emails"
	body "Some body here"
end # mail new

mail.deliver
