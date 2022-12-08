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

  def get_scenic_score(grid, row, col) do
    tree = grid |> Enum.at(row) |> Enum.at(col)

    scenic_score_above = check_direction(grid, :up, row, col, tree)
    scenic_score_below = check_direction(grid, :down, row, col, tree)
    scenic_score_left = check_direction(grid, :left, row, col, tree)
    scenic_score_right = check_direction(grid, :right, row, col, tree)

    scenic_score_above * scenic_score_below * scenic_score_left * scenic_score_right
  end

  def check_direction(grid, :up, row, col, tree) do
    Enum.reduce_while((row - 1)..0, 0, fn row, score ->
      cond do
        grid |> Enum.at(row) |> Enum.at(col) < tree ->
          {:cont, score + 1}

        grid |> Enum.at(row) |> Enum.at(col) >= tree ->
          {:halt, score + 1}
      end
    end)
  end

  def check_direction(grid, :down, row, col, tree) do
    Enum.reduce_while((row + 1)..(get_height(grid) - 1), 0, fn row, score ->
      cond do
        grid |> Enum.at(row) |> Enum.at(col) < tree ->
          {:cont, score + 1}

        grid |> Enum.at(row) |> Enum.at(col) >= tree ->
          {:halt, score + 1}
      end
    end)
  end

  def check_direction(grid, :right, row, col, tree) do
    Enum.reduce_while((col + 1)..(get_width(grid) - 1), 0, fn col, score ->
      cond do
        grid |> Enum.at(row) |> Enum.at(col) < tree ->
          {:cont, score + 1}

        grid |> Enum.at(row) |> Enum.at(col) >= tree ->
          {:halt, score + 1}
      end
    end)
  end

  def check_direction(grid, :left, row, col, tree) do
    Enum.reduce_while((col - 1)..0, 0, fn col, score ->
      cond do
        grid |> Enum.at(row) |> Enum.at(col) < tree ->
          {:cont, score + 1}

        grid |> Enum.at(row) |> Enum.at(col) >= tree ->
          {:halt, score + 1}
      end
    end)
  end
end

grid = GridParser.parse_grid("input.txt")

Enum.reduce(1..(GridParser.get_height(grid) - 2), [], fn row, scores ->
  scores_for_row =
    Enum.map(1..(GridParser.get_width(grid) - 2), fn col ->
      scenic_score = GridParser.get_scenic_score(grid, row, col)
    end)

  [scores_for_row | scores]
end)
|> List.flatten()
|> Enum.max()
|> IO.inspect()
