defmodule Day7.Lib do
  def parse_instructions(file) do
    File.read!(file)
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, fn line, {directory_size_map, current_directory_stack} ->
      case String.split(line, " ") do
        [_, "cd", directory] ->
          {directory_size_map, [directory | current_directory_stack]}

        [_, "cd", ".."] ->
          [_current_directory | rest_of_stack] = current_directory_stack
          {directory_size_map, rest_of_stack}

        [_, "ls"] ->
          [current_directory | _rest_of_stack] = current_directory_stack
          {Map.put(directory_size_map, current_directory, []), current_directory_stack}

        ["dir", directory_name] ->
          [current_directory | _rest_of_stack] = current_directory_stack
          current_directory_steps = Map.get(directory_size_map, current_directory)
          current_directory_steps = [directory_name | current_directory_steps]

          {Map.put(directory_size_map, current_directory, current_directory_steps),
           current_directory_stack}

        [file_size, _file_name] ->
          [current_directory | _rest_of_stack] = current_directory_stack
          current_directory_steps = Map.get(directory_size_map, current_directory)
          current_directory_steps = [String.to_integer(file_size) | current_directory_steps]

          {Map.put(directory_size_map, current_directory, current_directory_steps),
           current_directory_stack}
      end
    end)
  end

  def calculate_size(item, _full_map) when is_integer(item) do
    item
  end

  def calculate_size(item, full_map) when is_binary(item) do
    full_map
    |> Map.get(item)
    |> calculate_size(full_map)
  end

  def calculate_size(item, full_map) when is_list(item) do
    Enum.reduce(item, 0, fn item, acc ->
      acc + calculate_size(item, full_map)
    end)
  end
end

{map, _} = Day7.Lib.parse_instructions("input.txt")

IO.inspect(map)

calculations =
  Enum.map(map, fn {key, value} ->
    {key, Day7.Lib.calculate_size(value, map)}
  end)
  |> Enum.filter(fn {_, value} -> value <= 100_000 end)
  |> Enum.map(fn {_, value} -> value end)
  |> IO.inspect()
  |> Enum.sum()
  |> IO.inspect()
