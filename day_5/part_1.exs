defmodule Day3.Lib do
  def move(stacks, from, to, amount) do
    %{^from => from_stack} = stacks
    {taken, not_taken} = Enum.split(from_stack, String.to_integer(amount))
    stacks = Map.put(stacks, from, not_taken)

    %{^to => to_stack} = stacks

    new_stack =
      Enum.reduce(taken, to_stack, fn item, acc ->
        [item | acc]
      end)

    IO.puts("Taking #{amount} from #{inspect(from_stack)}")
    IO.inspect("Taken: #{inspect(taken)}")
    IO.inspect("Adding to: #{inspect(to_stack)}")
    IO.inspect("Result: #{inspect(new_stack)}")

    Map.put(stacks, to, new_stack)
  end
end

stacks = %{
  "1" => ["S", "P", "W", "N", "J", "Z"],
  "2" => ["T", "S", "G"],
  "3" => ["H", "L", "R", "Q", "V"],
  "4" => ["D", "T", "S", "V"],
  "5" => ["J", "M", "B", "D", "T", "Z", "Q"],
  "6" => ["L", "Z", "C", "D", "J", "T", "W", "M"],
  "7" => ["J", "T", "G", "W", "M", "P", "L"],
  "8" => ["H", "Q", "F", "B", "T", "M", "G", "N"],
  "9" => ["W", "Q", "B", "P", "C", "G", "D", "R"]
}

with file <- File.read!("input.txt") do
  file
  |> String.split("\r\n")
  |> Enum.reduce(stacks, fn line, acc ->
    [_, amount, _, from, _, to] = String.split(line)
    new_stacks = Day3.Lib.move(acc, from, to, amount)
  end)
  |> Enum.each(fn {_index, [first | _]} -> IO.puts(first) end)
end
