require 'net/smtp'
require 'rubygems'
require 'mailfactory'

mail = MailFactory.new()
mail.to = "kumakise@gmail.com"
mail.from = "me@localhost"
mail.subject = "Here are some files for you!"
mail.text = "This is what people with plain text mail readers will see"
mail.html = "A little something <b>special</b> for people with HTML readers"

Net::SMTP.start("smtp.gmail.com", 25) do |smtp|
	puts "We are connected"
	smtp.send_message mail.to_s, mail.from, [mail.to]
end # smtp

