class Game
	attr_reader :board, :player_human, :player_computer
  @@win_pattern = 
    [[0, 1 ,2], [3, 4, 5], [6, 7, 8], [0, 3, 6], 
     [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]] # winning pattern combinations
	def initialize
		@board = Board.new
		@board.print_board
		@player_human = Player.new('x')
		@player_human.get_name
		@player_computer = Player.new('o')
		@player_computer.get_name
		@winner = nil
		@current_turn = 1
	end

	

	def welcome 
		puts "Welcome to Tic-Tac-Toe, #{@player_human.name}"
		puts "Welcome to Tic-Tac-Toe, #{@player_computer.name}"

	end

  def play
  	welcome
    start_playing
    show_result
	end

	def start_playing
		while @current_turn < 9 && !@winner
			board.update(@player_human.get_moves, @player_human.sym)
			@current_turn += 1
			board.print_board
			check_if_win(@player_human)
			board.update(@player_computer.get_moves, @player_computer.sym)
			@current_turn += 1
			board.print_board
			show_result
			check_if_win(@player_computer)
		end
	end

	def show_result

	end

	def check_if_win(player)
  	@@win_pattern.each do |pattern|
  		if pattern.all? {|cell| cell == player.sym}
  			@winner = player
  		end
  	end
	end

	def game_over
	end

end

class Board
	attr_reader :board, :empty_cell

	def initialize
		@board = Array.new(9, @empty_cell)
	end

	def print_board
		puts "\n"
    @board.each_slice(3) { |row| puts row.join(' | ') }
    puts "\n"
	end

	def update(move, sym)
		@board[move] = sym
	end

end

class Player
	attr_reader :name, :sym
	def initialize(sym)
		@name = name
		@sym = sym
	end
	def get_name
		puts "What's your name?"
		@name = gets.chomp
	end
	def get_moves
		puts "Choose your moves from 1 to 9"
		move = gets.chomp.to_i - 1
	end

end

new_game = Game.new
new_game.play

