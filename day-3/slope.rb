class Slope
  attr_reader :trees

  def initialize(trees_file)
    @trees = File.readlines(trees_file, chomp: true)
  end

  def ride_slopes(slopes)
    slopes.reduce(1) { |memo, slope| memo * ride_toboccan(*slope) }
  end

  def ride_toboccan(dx, dy)
    x = 0
    y = 0

    tree_count = 0

    while y < slope_height
      x += dx
      y += dy
      tree_count += 1 if tree?(x, y)
    end

    tree_count
  end

  private

  def tree?(x, y)
    trees[y][x % slope_pattern_width] == "#"
  end

  def slope_height
    trees.size - 1
  end

  def slope_pattern_width
    trees.first.size
  end
end
