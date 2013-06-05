  def initializing
	@columns = [		#map of all places that are possible wins with an instance variable
	[:a1,:a2,:a3],
	[:b1,:b2,:b3],
	[:c1,:c2,:c3],
      
	[:a1,:b1,:c1],
	[:a2,:b2,:c2],
	[:a3,:b3,:c3],
      
	[:a1,:b2,:c3],
	[:c1,:b2,:a3]
	]
	@corners = [:a1, :a3, :c1, :c3]			#array for symbols for corners
	@center_edges = [:a2, :b1, :c2, :b3]	#initializing the array of symbols for the center edges
	@cpu = rand() > 0.5 ? 'X' : 'O'		#randomly selecting cpu's mark
	@user = @cpu == 'X' ? 'O' : 'X'		#selecting user mark after random selection of cpu's mark
	@cpu_name = "La Maquina"			#names the cpu
	put_line
	puts "\n  			Hector's Game of TIC TAC TOE"#greets the player
	print "\n What is your name? "		#asks players name
	STDOUT.flush						#cleans buffer
	@user_name = gets.chomp			#retrieves players name
	put_bar
	@user_score = 0					#assigns the beginnning players score
	@cpu_score = 0					#assignes the beginning cpus score
	start_game(@user == 'X')			#starts the game
  end

  def start_game(user_goes_first)			#start game method
	@places = {		#the tic tac toe slots.  It defines the hash variable @places with keys and empty spaces as values
	a1:" ",a2:" ",a3:" ",
	b1:" ",b2:" ",b3:" ",
	c1:" ",c2:" ",c3:" "
	}	

	if user_goes_first					#iteration for user turn or cpu turn
		user_turn
	else
		cpu_turn
	end
  end

  def restart_game(user_goes_first)			#re-start game method
	(1...20).each { |i| put_line }
	start_game(user_goes_first)
  end
  
  def put_line							#prints line method
	puts ("-" * 50)
  end
  
  def put_bar							#prints bar method
	puts ("#" * 50)
  end
  
  def draw_game						#draw the board method
	#puts ""
	puts "\nWins: #{@cpu_name}:#{@cpu_score} 		#{@user_name}:#{@user_score}"
	#puts ""
	puts "\n#{@cpu_name}'s Symbol is #{@cpu}	#{@user_name}'s Symbol is #{@user}"
	puts ""
	puts "          a   b   c"
	puts ""
	puts "      1   #{@places[:a1]} | #{@places[:b1]} | #{@places[:c1]} "
	puts "         --- --- ---"
	puts "      2   #{@places[:a2]} | #{@places[:b2]} | #{@places[:c2]} "
	puts "         --- --- ---"
	puts "      3   #{@places[:a3]} | #{@places[:b3]} | #{@places[:c3]} "
  end
  
  def cpu_turn							#cpus turn method
	move = cpu_find_move				#makes the variable move equal to the return symbol from the cpu_find_method
	@places[move] = @cpu				#places cpu mark into the chosen move
	put_line
	puts " #{@cpu_name} marks #{move.to_s.upcase}"
	check_game(@user)
  end
  
  def cpu_find_move
	@columns.each do |column|	#doublecheck if cpu can win
		if times_in_column(column, @cpu) == 2
			return empty_in_column column
		end
	end

	@columns.each do |column|	#doublecheck if user can win
		if times_in_column(column, @user) == 2
			return empty_in_column column
		end
	end
#--------strategic moves------------
	if corners_one_usermark == 1	#marks center if user marked corner
		return :b2 if " " == @places[:b2]
	end
	if @user == @places[:b2]	&& cpu_marked_corners < 2	#marks corner if user marked center
		return corners_one_blank #if cpu_marked_corners < 2
	end
	if 2 == cpu_marked_corners && " " == @places[:b2] #Method that forces a cpu win if two of the corners are cpu marked and the center is opened
		return :b2
	end
	if 1 == cpu_marked_corners && 0 == corners_one_usermark && " " == @places[:b2]
		return :b2	#helps force a center move---These method can be beefed up to force a win by cpu
	end
	if @places[:b1] == @user && @places[:c1] != @cpu && @places[:a1] == " "	#method to take care of b1 move 			 
		return :a1
		else if @places[:b1] == @user && @places[:a1] != @cpu && @places[:c1] == " "				#
			return :c1
		end
	end
	if @places[:b3] == @user && @places[:c3] != @cpu && @places[:a3] == " "	#method to take care of b3 move			
		return :a3
		else if @places[:b3] == @user && @places[:a3] != @cpu && @places[:c3] == " "					#
			return :c3
		end
	end
	if @user == @places[:c2] && @places[:c3] != @cpu && " " == @places[:c1] 	#method to take care of c2 move		
		return :c1
		else if @user == @places[:c2] && @places[:c1] != @cpu && " " == @places[:c3]					#
			return :c3
		end
	end
	if @places[:a2] == @user && @places[:a3] != @cpu && @places[:a1] == " "	#method to take care of a2 move			
		return :a1
		else if @places[:a2] == @user && @places[:a1] != @cpu && @places[:a3] == " "					#
			return :a3
		end
	end
#--------end of strategic moves ------------ 
	@columns.each do |column|	#check if winning columns have one cpu mark
		if times_in_column(column, @cpu) == 1
			return empty_in_column column
		end
	end
    
	k = @places.keys;	#if not strategic place found for cpu it picks randomly
	i = rand(k.length)
	if @places[k[i]] == " "
		return k[i]
	else
		@places.each { |k,v| return k if v == " " } #random selection is taken so just find the first empty slot
	end
  end
  
  def times_in_column arr, item	#generic method to find how many marks of either player are set for win
	times = 0
		arr.each do |i| 
			times += 1 if @places[i] == item
			unless @places[i] == item || @places[i] == " "
			#oppisite piece is in column so column cannot be used for win.
			#therefore, the strategic thing to do is choose a dif column so return 0.
				return 0
			end
		end
	times
  end
  
  def empty_in_column arr	#method to pick what spot is empty
		arr.each do |i| 
			if @places[i] == " "
				return i
			end
		end
  end
  #----methods for strategic moves above------
	def corners_one_usermark #determine if the corners have 1 user mark
	count = 0
		@corners.each do |corner|
			count += 1 if @places[corner] == @user
		end
	return count #if 1 == count
	end
	def cpu_marked_corners	#determining how many corners are cpu marked
	times_corner = 0
		@corners.each do |corner| 
			times_corner += 1 if @places[corner] == @cpu
		end
	return times_corner
	end
	def corners_one_blank	#determine if corners are blank and returns the corner symbol
	count = 0
		@corners.each do |corner|
			if @places[corner] == " "
				return corner
				count += 1
			end
		end
	end	
  #----end of methods for strategic moves above------
  def user_turn		#method that retrieves the players move and makes sure that is in an empty slot of formated correctly
	put_line
	draw_game
	print "\n #{@user_name}, why don't you make a move or type 'exit' to quit? "
	STDOUT.flush
	input = gets.chomp.downcase.to_sym
	put_bar
	if input.length == 2
	a = input.to_s.split("")
		if(['a','b','c'].include? a[0])
			if(['1','2','3'].include? a[1])
				if @places[input] == " "
					@places[input] = @user
					put_line
					puts " #{@user_name} marks #{input.to_s.upcase}"
					check_game(@cpu)
				else
					wrong_move
				end
			else
				wrong_input
			end
		else
			wrong_input
		end
	else
		wrong_input unless input == :exit
		puts "\n 	Goodbye! -- Thanks for Playing #{@user_name}"
	end
  end
  
  def wrong_input
	put_line
	puts " Please specify a move with the format 'A1' , 'B3' , 'C2' etc."
	user_turn
  end
  
  def wrong_move
	put_line
	puts " You must choose an empty slot"
	user_turn
  end
  
  def moves_left
	@places.values.select{ |v| v == " " }.length
  end
  
  def check_game(next_turn)	#method to check game for wins
  	game_over = nil
    	@columns.each do |column|
      		if times_in_column(column, @cpu) == 3	# see if cpu has won
			put_line
			draw_game
			put_line
			puts ""
			puts " Ha Ha!  Somebody needs to practice -- #{@cpu_name} WINS!!!\n"
			game_over = true
			@cpu_score += 1
			ask_to_play_again(true) #it was false before i changed it
		end
      		if times_in_column(column, @user) == 3	# see if user has won
			put_line
			draw_game
			put_line
			puts ""
			puts " You got lucky this time! -- #{@user_name} WINS!!!\n"
			game_over = true
			@user_score += 1
			ask_to_play_again(rand() > 0.5) #it was true before i changed it
		end
	end
    
	unless game_over	#method to check game for draw
		if(moves_left > 0)
			if(next_turn == @user)
				user_turn
			else
				cpu_turn
			end
		else
				put_line
				draw_game
				put_line
				puts ""
				puts " Game Over -- DRAW!\n"
				ask_to_play_again(rand() > 0.5)
		end
	end
  end

  def ask_to_play_again(user_goes_first)
	print "\n Play again? (yes or no): "
	STDOUT.flush
	response = gets.chomp.downcase
	case response
		when "y" then restart_game(user_goes_first)
		when "yes" then restart_game(user_goes_first)
		when "n" then :exit
		when "no" then :exit 
	else ask_to_play_again(user_goes_first)
	end
  end

initializing