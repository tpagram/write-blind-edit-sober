require 'io/console'


class WriteBlind
 	
	def initialize output, prompt
		@file = File.open(output, "a") unless output.nil?
		@prompt = prompt
		@text = ""
	end 

	def startSession
		word = ""
		print_word word
		while true do 
			char = STDIN.getch
			case char
			when "\e", "\u0003" #escape, ctrl-c
				write_word word
				puts "Session finished. Nice! You wrote #{@text.split.size.to_s} words.\n\n"
				puts @text
				exit
			when " "
				write_word word
				word = ""
				print_word word
			when "\r" #return
				write_word word + "\n"
				word = ""
				print_word word
			when "\u007F" #backspace
				word = word[0..word.length-2]
				print_word word
			else
				word = word + char unless word.length > 45
				print_word word
			end
		end
	end

	def print_word word
		columns = `tput cols`.to_i
		word_count = "(" + @text.split.size.to_s + " words)"
		whitespace = columns - @prompt.length - word.length - word_count.length
		print @prompt + word + (1..whitespace).map {" "}.join + word_count + "\r"
		STDOUT.flush
	end

	def write_word word
		if !@text.empty? && @text[-1] != "\n"
			@text += " " + word
			@file.write(" " + word) unless @file.nil?
		else
			@text += word
			@file.write(word) unless @file.nil?
		end
	end

	def add_whitespace(n)
		return (1..n).map {" "}.join
	end

end

WriteBlind.new(ARGV[0]," >>> ").startSession