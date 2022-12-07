defmodule Day6.Lib do
  def check_fourteen(char_list) do
    if char_list |> Enum.take(14) |> Enum.uniq_by(fn {letter, _} -> letter end) |> length() < 14 do
      [_ | rest_of_list] = char_list
      check_fourteen(rest_of_list)
    else
      {_, last_index} = char_list |> Enum.take(14) |> List.last()
      IO.puts("Number of characters processed: #{last_index + 1}")
    end
  end
end

with file <- File.read!("input.txt") do
  String.graphemes(file)
  |> Enum.with_index()
  |> Day6.Lib.check_fourteen()
end
