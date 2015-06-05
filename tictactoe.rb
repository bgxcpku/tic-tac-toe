## This is the project for Flatiron School interview by Steve Xie
## It allows either two human or 1 human and 1 computer to play tic tac toe in 3x3 grid

class Game
	attr_reader :board, :player_1, :player_2
 
  @@win_pattern =   # winning pattern combinations
  	[[0, 1 ,2], [3, 4, 5], [6, 7, 8], [0, 3, 6], 
  	[1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]] 

  @@half_win_pattern = Array.new # half_win_pattern (either two elements from winning pattern) 
  @@win_pattern.each do |a,b,c|  
  	@@half_win_pattern << [a, b]
  	@@half_win_pattern << [a, c]
  	@@half_win_pattern << [b, c]
  end

	def initialize
		@board = Board.new #create the grid
		puts "Tic-Tac-Toe Game"
		@board.print_board
		@player_1 = Player.new('x','N') #create player 1 (human)
    puts "What's Player 1's name?"
		@player_1.get_name
		puts "Do you want to play with computer? (Y/N)" #user can choose to player with computer (Potato) or another human
		answer = gets.chomp
		while answer != 'Y' && answer != 'N'
			puts "Please choose only Y or N", "\n"
			answer = gets.chomp
		end
		@player_2 = Player.new('o', answer) #create player 2, (human or computer depending on user's choice)
		if answer == 'N'
			puts "What's Player 2's name?"
		end
		@player_2.get_name
		@winner = nil
		@current_turn = 1
	end

	def play
  	welcome(@player_1)
  	welcome(@player_2)
    start_playing
    show_result
	end

	def welcome(player) 
		if player.computer_player == 'N'
			puts "Welcome to Tic-Tac-Toe, #{player.name}", "\n"
		else
		  sleep 0.25
			puts "Our smart computer Potato joins the game!", "\n"
		end
	end

	def start_playing
		while @current_turn <= 9 && !@winner #player_1 and player_2 switch turns
			take_turns
		end
	end

	def take_turns
		if @current_turn %2 == 1 #use the odd or even of @current_turn to check which player's turn it is
			turn(@player_1)
		elsif @player_2.computer_player == 'N'
			turn(@player_2)
		else
			smart_computer	#smart_computer makes player_2's move if user choose to play with computer
		end
	end

	def turn(player) 
		if @board.update(player.get_moves, player.sym) #get user's move
			@current_turn += 1
			@board.print_board #show user's move
			check_if_win(player) #check if user win
		else
			puts "You can't choose it, please choose again from #{(@board.available).collect {|x| x+1}}"
		end
	end

	def smart_computer	
		move = nil	
		move = check_if_half_win(@player_2, @player_1) #check if computer has a half_win_pattern
    if move == nil
    	move = check_if_half_win(@player_1, @player_2) #if no move, check if player_1 has a half_win_pattern
    	if move == nil #if neither player has a half_win_pattern, just choose a random available cell
    		move = @board.available.sample
    	end
    end
		@board.update(move, player_2.sym)	
		@player_2.all_moves << move #update player_2's all moves
		@current_turn += 1
		puts "Potato is making his next move", "\n"
		sleep 0.25
		puts "Potato picks #{move+1}", "\n"
		sleep 0.25
		@board.print_board
		check_if_win(player_2)
	end

  def check_if_win(player) #check if player wins
  	@@win_pattern.each do |pattern|
  		if pattern.all? {|cell| @board.grid[cell] == player.sym}
  			@winner = player
  		end
  	end
	end

  def check_if_half_win(player_a, player_b) #this is used by computer to check if player_a (could be 1 or 2) has winning chance 	
  	move = nil
  	@@half_win_pattern.each do |pattern|
	    if (player_a.all_moves&pattern).length == 2 #if player_a has got two elements in winning patter
	      @@win_pattern.each do |win_pattern| 
	      	#and neither player_a nor player_b hasn't taken the third element yet
	        if (win_pattern - pattern).length == 1 && ((win_pattern - pattern)&player_b.all_moves).empty? && ((win_pattern - pattern)&player_a.all_moves).empty?
	          move = (win_pattern - pattern)[0] 
	        end
	      end
	    end
    end
    return move
	end

	def show_result #print results if either has a winner or draw
		if @winner
			puts "#{@winner.name} wins"
		else
			puts "draw"
		end
	end

end

class Board #creates 3x3 board, user input from 1-9
	attr_reader :grid, :empty_cell, :available

	def initialize
		@empty_cell = '-'
		@grid = Array.new(9, @empty_cell) 
		@available = Array (0..8)
	end

	def update(move, sym) #update move on the board
		if @grid[move] == @empty_cell && move >=0 && move <=8 
			@grid[move] = sym
			@available.delete(move) 
			puts move 
			return true
		else
			return false
		end
	end

	def print_board #print board
		puts "\n"
    @grid.each_slice(3) {|row| puts row.join(' | ')}
    puts "\n"
	end

end

class Player #create players
	attr_reader :name, :sym, :computer_player, :all_moves

	def initialize(sym, computer_player)
		@name = name
		@sym = sym #put either 'o' or 'x' in the cell
		@computer_player = computer_player 
		@all_moves = Array.new # all_moves collects this player's all moves in order for computer to make move
	end

	def get_name
		if @computer_player == 'Y'
			@name = 'Potato' #give computer a cute name (my pug's name)
		else
			@name = gets.chomp
		end
	end

	def get_moves #to get human player's move 
		puts "Choose your moves from 1 to 9, #{@name}"
		move = gets.chomp.to_i - 1
		if move >= 0 && move <=8
			all_moves << move #save the move to all moves for this player
		end
		return move  
	end

end

new_game = Game.new
new_game.play

