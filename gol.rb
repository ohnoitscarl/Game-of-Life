
#Author Richard Wilmer
class Game
  attr_accessor :universe

  def initialize(universe=Universe.new, seeds=[])
    @universe = universe
    seeds.each do |seed|
      universe.cell_grid[seed[0]][seed[1]].alive = true
    end
  end

  def tick!
    next_round_live_cells = []
    next_round_dead_cells = []

    @universe.cells.each do |cell|
      neighbour_count = self.universe.live_neighbours_around_cell(cell).count
      # Scenario 1 - Underpopulation:
      # When a live cell has fewer than two neighbours then this cell dies
      if cell.alive? && neighbour_count < 2
        next_round_dead_cells << cell
      end
      # Scenario 2 - Overcrowding:
      # When a live cell with two or three live neighbours lives on to the next generation
      if cell.alive? && neighbour_count > 3
        next_round_live_cells << cell
      end
      # Scenario 3 - Survival:
      # When a live cell has more than three live neighbours it dies

        if cell.alive? && ([2, 3].include? neighbour_count)
          next_round_dead_cells << cell
      end
      # Scenario 4 - Creation of life:
      # When an empty position has exactly three neighbouring cells then a cell is created in this position
      if cell.dead? && neighbour_count == 3
        next_round_live_cells << cell
      end
    end

    next_round_live_cells.each do |cell|
      cell.revive!
    end
    next_round_dead_cells.each do |cell|
      cell.die!
    end
  end
end

class Universe
  attr_accessor :rows, :cols, :cell_grid, :cells

  def initialize(rows=3, cols=3)
    @rows = rows
    @cols = cols
    @cells = []

#Grid in universe has array in array, new cell object created on each element of hte second array
    @cell_grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(col, row)
      end
    end

    cell_grid.each do |row|
      row.each do |element|
        if element.is_a?(Cell)
          cells << element
        end
      end
    end

  end

  def live_cells
    cells.select { |cell| cell.alive }
  end

  def dead_cells
    cells.select { |cell| cell.alive == false }
  end

  def live_neighbours_around_cell(cell)
    live_neighbours = []
    # Neighbour to the North-East
    if cell.y > 0 and cell.x < (cols - 1)
      candidate = self.cell_grid[cell.y - 1][cell.x + 1]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbour to the South-East
    if cell.y < (rows - 1) and cell.x < (cols - 1)
      candidate = self.cell_grid[cell.y + 1][cell.x + 1]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbours to the South-West
    if cell.y < (rows - 1) and cell.x > 0
      candidate = self.cell_grid[cell.y + 1][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbours to the North-West
    if cell.y > 0 and cell.x > 0
      candidate = self.cell_grid[cell.y - 1][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbour to the North
    if cell.y > 0
      candidate = self.cell_grid[cell.y - 1][cell.x]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbour to the East
    if cell.x < (cols - 1)
      candidate = self.cell_grid[cell.y][cell.x + 1]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbour to the South
    if cell.y < (rows - 1)
      candidate = self.cell_grid[cell.y + 1][cell.x]
      live_neighbours << candidate if candidate.alive?
    end
    # Neighbours to the West
    if cell.x > 0
      candidate = self.cell_grid[cell.y][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end
    live_neighbours
  end

  def randomly_populate
    cells.each do |cell|
      cell.alive = [true, false].sample
    end
  end

end

class Cell
  attr_accessor :x, :y, :alive
  # Cell has x,y coordinates and is either alive or dead
  def initialize(x=0, y=0)
    @x = x
    @y = y
    @alive = false
  end


  def alive?; alive; end
  def dead?; !alive; end

  def die!
    @alive = false
  end
  def revive!
    @alive = true # same as > self.alive = true
  end
end
