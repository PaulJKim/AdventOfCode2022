defmodule GridParser do
  def parse_grid(file) do
    File.read!(file)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.graphemes(line) |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_height(grid) do
    length(grid)
  end

  def get_width(grid) do
    length(grid |> List.first())
  end

  def is_visible?(grid, row, col) do
    tree = grid |> Enum.at(row) |> Enum.at(col)

    trees_above = check_direction(grid, :up, row, col)
    visible_above? = not Enum.any?(trees_above, fn x -> x >= tree end)
    trees_below = check_direction(grid, :down, row, col)
    visible_below? = not Enum.any?(trees_below, fn x -> x >= tree end)
    trees_left = check_direction(grid, :left, row, col)
    visible_left? = not Enum.any?(trees_left, fn x -> x >= tree end)
    trees_right = check_direction(grid, :right, row, col)
    visible_right? = not Enum.any?(trees_right, fn x -> x >= tree end)

    visible_above? or visible_below? or visible_left? or visible_right?
  end

  def check_direction(grid, :up, row, col) do
    Enum.map((row - 1)..0, fn row ->
      grid |> Enum.at(row) |> Enum.at(col)
    end)
  end

  def check_direction(grid, :down, row, col) do
    Enum.map((row + 1)..(get_height(grid) - 1), fn row ->
      grid |> Enum.at(row) |> Enum.at(col)
    end)
  end

  def check_direction(grid, :right, row, col) do
    Enum.map((col + 1)..(get_width(grid) - 1), fn col ->
      grid |> Enum.at(row) |> Enum.at(col)
    end)
  end

  def check_direction(grid, :left, row, col) do
    Enum.map((col - 1)..0, fn col ->
      grid |> Enum.at(row) |> Enum.at(col)
    end)
  end
end

grid = GridParser.parse_grid("input.txt")

Enum.reduce(1..(GridParser.get_height(grid) - 2), 0, fn row, acc ->
  Enum.map(1..(GridParser.get_width(grid) - 2), fn col ->
    if GridParser.is_visible?(grid, row, col) do
      1
    else
      0
    end
  end)
  |> Enum.sum()
  |> Kernel.+(acc)
end)
|> Kernel.+(GridParser.get_height(grid) * 2 + GridParser.get_width(grid) * 2 - 4)
|> IO.inspect()
