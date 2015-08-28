require 'colorize'

class Board
	#COLORS = ["A", "B", "C", "D", "E", "F"]
	COLORS = ["B", "R", "G", "Y", "M", "W"]
	LEGEND = [
			"[B]lue".colorize(:blue),
			"[R]ed".colorize(:red),
			"[G]reen".colorize(:green),
			"[Y]ellow".colorize(:yellow),
			"[M]agenta".colorize(:magenta),
			"[W]hite".colorize(:white)
		]
	MAX_GUESSES = 12
	
	def initialize
		generateSecretCode
	end

	def printLegend
		LEGEND.each { |command| print command + "  " }
		puts
	end

	def generateSecretCode
		random = Random.new
		@secret_code = []
		4.times { @secret_code.push COLORS[random.rand(0..COLORS.length-1)] }
		
		# Uncomment this line so that you can see the secret code for debug purposes
		#puts "DEBUG: Secret code is #{@secret_code}"
	end

	# Return hash containing # correct guesses (black)
	# and number of correct colors in wrong spot (white)
	def compareGuessToSecretCode(guess)
		results = Hash.new
		secret_code_leftovers = Hash.new(0)
		guess_leftovers = Hash.new(0)
		black_pegs = 0
		white_pegs = 0
		(0..3).each do |i|
			if ( @secret_code[i] == guess[i] )  # exact match, count as black peg
				black_pegs += 1
			else 
				# keep a count of pegs seen that did not match exactly, we'll deal with them a bit later
				secret_code_leftovers[@secret_code[i]] += 1
				guess_leftovers[guess[i]] += 1
			end
		end

		# colors existed, but were not exact match, count as white peg
		secret_code_leftovers.each do |k,v|
			white_pegs += [v, guess_leftovers[k]].min
		end

		results[:black] = black_pegs
		results[:white] = white_pegs
		results
	end

	def drawPegs(results)
		print "Pegs: "
		results[:white].times { print "  ".colorize(:background => :white); print "  "}
		results[:black].times { print "  ".colorize(:background => :black); print "  " }	
		puts
	end

	def promptUser
		MAX_GUESSES.times do
			puts "Enter your guess, separated by spaces (e.g. #{"B".colorize(:blue)} #{"R".colorize(:red)} #{"G".colorize(:green)} #{"Y".colorize(:yellow)})"
			a, b, c, d = gets.chomp.split
			guess = [a,b,c,d]
			results = compareGuessToSecretCode(guess)
			#puts results.inspect
			drawPegs(results)
			if (results[:black] == 4 )
				puts "Congratulations, you win!"
				break
			end
		end
	end
end

b = Board.new
b.printLegend
b.promptUser
