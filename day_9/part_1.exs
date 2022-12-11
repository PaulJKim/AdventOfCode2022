defmodule DynamicGridTraverse do
  def traverse_tail(head_positions, tail_start, visited_set) do
    {tail_new_position, _, tail_visited_set} =
      Enum.reduce(
        0..(length(head_positions) - 1),
        {tail_start, tail_start, visited_set},
        fn head_positions_index, {tail_current, tail_prev, tail_visited_set} ->
          if is_touching?(Enum.at(head_positions, head_positions_index), tail_current) do
            {tail_current, tail_prev, tail_visited_set}
          else
            tail_new_position = Enum.at(head_positions, head_positions_index - 1)

            {tail_new_position, tail_current, MapSet.put(tail_visited_set, tail_new_position)}
          end
        end
      )

    {tail_new_position, tail_visited_set}
  end

  def traverse({"R", count}, {x, y}) do
    for i <- 0..count do
      {x + i, y}
    end
  end

  def traverse({"L", count}, {x, y}) do
    for i <- 0..count do
      {x - i, y}
    end
  end

  def traverse({"U", count}, {x, y}) do
    for i <- 0..count do
      {x, y + i}
    end
  end

  def traverse({"D", count}, {x, y}) do
    for i <- 0..count do
      {x, y - i}
    end
  end

  defp is_adjacent?({head_x, head_y}, {tail_x, tail_y}) do
    (head_x == tail_x and (head_y == tail_y + 1 or head_y == tail_y - 1)) or
      (head_y == tail_y and (head_x == tail_x + 1 or head_x == tail_x - 1))
  end

  defp is_diagonal?({head_x, head_y}, {tail_x, tail_y}) do
    (head_x == tail_x + 1 and head_y == tail_y + 1) or
      (head_x == tail_x + 1 and head_y == tail_y - 1) or
      (head_x == tail_x - 1 and head_y == tail_y + 1) or
      (head_x == tail_x - 1 and head_y == tail_y - 1)
  end

  defp is_overlapping?({head_x, head_y}, {tail_x, tail_y}) do
    head_x == tail_x and head_y == tail_y
  end

  def is_touching?(head, tail) do
    is_adjacent?(head, tail) or is_diagonal?(head, tail) or is_overlapping?(head, tail)
  end
end

{head_last_position, tail_last_position, tail_visited} =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new([{0, 0}])}, fn move,
                                                            {head_current, tail_current,
                                                             tail_visited} ->
    [direction, count] = String.split(move, " ")

    head_moves = DynamicGridTraverse.traverse({direction, String.to_integer(count)}, head_current)

    {tail_new, tail_visited} =
      DynamicGridTraverse.traverse_tail(head_moves, tail_current, tail_visited)

    {List.last(head_moves), tail_new, tail_visited}
  end)

IO.inspect(MapSet.size(tail_visited))
