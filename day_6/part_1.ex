defmodule Day6.Lib do
  def check_four([a, b, c, d | _] = char_list) do
    if Enum.uniq_by([a, b, c, d], fn {letter, _} -> letter end) |> length() < 4 do
      [_ | rest_of_list] = char_list
      check_four(rest_of_list)
    else
      {_, last_index} = d
      IO.puts("Number of characters processed: #{last_index + 1}")
    end
  end
end

with file <- File.read!("input.txt") do
  String.graphemes(file)
  |> Enum.with_index()
  |> Day6.Lib.check_four()
end
