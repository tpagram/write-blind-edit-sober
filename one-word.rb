require 'io/console'

text = ""

print " > \r"
word = ""
while true do 
	current_character = STDIN.getch
	case current_character
	when "\e", "\u0003"
		puts text
		exit
	when " "
		print "> " + (1..word.length+2).map {" "}.join + "\r"
		STDOUT.flush
		text = text + " " + word
		word = ""
	else
		word = word + current_character
		print "> #{word}\r"
		STDOUT.flush
	end
end

