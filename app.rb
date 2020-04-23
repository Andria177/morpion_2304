
class Player #A dispatcher dans des fichiers par classe plus tard
  attr_accessor :name, :choice

  def initialize(name, choice, board)
    @name = name
    @choice = choice
    @board = board
  end

  def move(cell)
    @board.update_cell(cell, self.choice)
  end

  def victory?
    wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]]
    wins.each do |win|
      values = [cells[win[0]], cells[win[1]], cells[win[2]]]
      return true if values.include?(self.choice.to_s) &&
      ((values[0] == values[1]) && (values[1] == values[2]))
    end
    false
  end

  private
  def cells
    @board.cells
  end

end

class Board
  attr_accessor :cells

  def initialize
    @cells = [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9"
    ]
  end

  def update_cell(number, choice)
    if cell_free?(number)
      self.cells[number - 1] = choice.to_s
      show_board
    else
      puts "Cette case n'est pas vide! Veuillez choisir une autre!"
      return false
    end
  end

  def show_board  # Code passé par Max D mais lui redemander pour hline et vline valeurs \u..., qu'est ce que cela veut dire
    hline = "\u2502"
    vline = "\u2500"
    cross = "\u253C"
    row1 = " " + self.cells[0..2].join(" #{hline} ")
    row2 = " " + self.cells[3..5].join(" #{hline} ")
    row3 = " " + self.cells[6..8].join(" #{hline} ")
    separator = vline * 3 + cross + vline * 3 + cross + vline * 3
    system("clear")
    puts row1
    puts separator
    puts row2
    puts separator
    puts row3
  end


  private
  def cell_free?(number)
    cell = self.cells[number - 1]
    if cell == "X" ||  cell == "O"
      false
    else
      true
    end
  end

end

class Game

  def initialize
    @board = Board.new
    @current_player = ""
    @winner = false
    @turn = 0
  end

  def start_game
    names = get_names
    @player1 = Player.new(names[0], :X, @board)
    @player2 = Player.new(names[1], :O, @board)
    @current_player = @player1
    @board.show_board
    turn until @winner || @turn == 9
    if @winner
      puts "#{@winner.name} a gagné avec panache!"
    else
      puts "Bravo! Vous avez gagné tous les deux"
    end
  end

  private

  def turn
    puts " C'est le tour de #{@current_player.name}. Choisissez entre les cases (1-9): "
    choice = gets.chomp.to_i
    if choice > 9 || choice < 1
      puts "Avertissement: Votre choix doit se faire entre les cases vides de 1 à 9!"
    elsif @current_player.move(choice) != false
      @winner = @current_player if @current_player.victory?
      @turn += 1
      switch_player
    end
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def get_names
    puts "Nom du joueur utilisant le X: "
    name1 = gets.chomp
    puts "Nom du joueur utilisant le 0: "
    name2 = gets.chomp
    [name1, name2]
  end

end

game = Game.new
game.start_game
