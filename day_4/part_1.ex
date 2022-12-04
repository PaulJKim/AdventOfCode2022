defmodule MyLib do
  def range_to_set(range) do
    [lower, upper] = String.split(range, "-")
    Enum.to_list(String.to_integer(lower)..String.to_integer(upper)) |> MapSet.new()
  end
end

with file <- File.read!("input.txt") do
  count =
    file
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc ->
      case String.split(line, ",") do
        [range_1, range_2] ->
          set_1 = MyLib.range_to_set(range_1)

          set_2 = MyLib.range_to_set(range_2)

          intersect = MapSet.intersection(set_1, set_2)

          if(set_1 == intersect or set_2 == intersect) do
            acc + 1
          else
            acc
          end

        _ ->
          acc
      end
    end)

  IO.puts(count)
end
