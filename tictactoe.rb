class Game
	attr_reader :board, :player_1, :player_2

  @@win_pattern = [[0, 1 ,2], [3, 4, 5], [6, 7, 8], [0, 3, 6], 
     [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]] # winning pattern combinations
  @@half_win_pattern = Array.new
  @@win_pattern.each do |a,b,c| 
  	@@half_win_pattern << [a, b]
  	@@half_win_pattern << [a, c]
  	@@half_win_pattern << [b, c]
  end
  print @@half_win_pattern
	def initialize
		@board = Board.new
		@board.print_board
		@player_1 = Player.new('x','N')
		@player_1.get_name
		puts "Do you want to play with computer? (Y/N)"
		@player_2 = Player.new('o', gets.chomp)
		@player_2.get_name
		@winner = nil
		@current_turn = 1
	end

	

	def welcome 
		puts "Welcome to Tic-Tac-Toe, #{@player_1.name}"
		puts "Welcome to Tic-Tac-Toe, #{@player_2.name}"

	end

  def play
  	welcome
    start_playing
    show_result
	end

	def start_playing
		while @current_turn <= 9 && !@winner
			take_turns
		end
	end

	def take_turns
		if @current_turn %2 == 1 
			turn(@player_1)
		elsif @player_2.computer_player == 'N'
			turn(@player_2)
		else
			smart_2	
		end
	end

	def turn(player)
		if @board.update(player.get_moves, player.sym)
			@current_turn += 1
		else
			puts "You can't choose here"
		end
		@board.print_board
		#puts @board.available
		check_if_win(player)
	end

	def smart_2	
		# if 1st move, pick center, if not available, pick any left
		# if not 1st move, (1)check if 1's can be a line , defense (2)if not, attack: if it has
		# two in a winning pattern and the third is available, then pick it, else random
		#if @current_turn <= 2
		#	@board.update(4, player_2.sym)
		#end
		#if @current_turn <= 2 && @board.available.include? 4
		#	@board.update(4, player_2.sym)
		#elsif 
		#end
		move = nil	
    @@half_win_pattern.each do |pattern|
	    if (@player_2.all_moves&pattern).length == 2
	      @@win_pattern.each do |win_pattern| 
	        if (win_pattern - pattern).length == 1 && ((win_pattern - pattern)&@player_1.all_moves).empty? && ((win_pattern - pattern)&@player_2.all_moves).empty?
	          move = (win_pattern - pattern)[0]   
	        	print move    
	        end
	      end
	    end
    end

    if move == nil
      @@half_win_pattern.each do |pattern|
        if (@player_1.all_moves&pattern).length == 2
          @@win_pattern.each do |win_pattern| 
        	  if (win_pattern - pattern).length == 1 && ((win_pattern - pattern)&@player_1.all_moves).empty? && ((win_pattern - pattern)&@player_2.all_moves).empty?
        		  move = (win_pattern - pattern)[0]
        	  end
          end
        end
      end
    	if move == nil
    		move = @board.available.sample
    	end
    end
    print move
		@board.update(move, player_2.sym)	
		@player_2.all_moves << move
		@player_2.all_moves.sort
		@current_turn += 1
		puts "Potato is making his next move"
		@board.print_board
		#puts @board.available
		check_if_win(player_2)
	end

	def show_result
		if @winner
			puts "#{@winner.name} wins"
		else
			puts "draw"
		end
	end

	def check_if_win(player)
  	@@win_pattern.each do |pattern|
  		if pattern.all? {|cell| @board.board[cell] == player.sym}
  			@winner = player
  		end
  	end
	end

	def game_over
	end

end

class Board
	attr_reader :board, :empty_cell, :available

	def initialize
		@empty_cell = '-'
		@board = Array.new(9, @empty_cell)
		@available = Array (0..8)
	end

	def print_board
		puts "\n"
    @board.each_slice(3) { |row| puts row.join(' | ') }
    puts "\n"
	end

	def update(move, sym)
		#print move 
		if @board[move] == @empty_cell
			@board[move] = sym
			@available.delete(move) 
			return true
		else
			return false
		end
	end


end

class Player
	attr_reader :name, :sym, :computer_player, :all_moves
	def initialize(sym, computer_player)
		@name = name
		@sym = sym
		@computer_player = computer_player
		@all_moves = Array.new
	end
	def get_name
		if @computer_player == 'Y'
			@name = 'Potato'
		else
			puts "What's your name?"
			@name = gets.chomp
		end
	end
	def get_moves
		puts "Choose your moves from 1 to 9"
		move = gets.chomp.to_i - 1
		@all_moves << move
		@all_moves.sort
		return move  
	end

end

new_game = Game.new
new_game.play

