defmodule Day7.Lib do
  def parse_input(file) do
    File.read!(file)
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, fn line, {directory_contents, directory_stack} ->
      case String.split(line, " ") do
        [_, "cd", directory] ->
          {directory_contents, [directory | directory_stack]}

        [_, "cd", ".."] ->
          [_current_directory | rest_of_stack] = directory_stack
          {directory_contents, rest_of_stack}

        [_, "ls"] ->
          [current_directory | _rest_of_stack] = directory_stack
          {Map.put(directory_contents, current_directory, []), directory_stack}

        ["dir", directory_name] ->
          [current_directory | _rest_of_stack] = directory_stack
          outputs = Map.get(directory_contents, current_directory)
          outputs = [directory_name | outputs]

          {Map.put(directory_contents, current_directory, outputs), directory_stack}

        [file_size, _file_name] ->
          [current_directory | _rest_of_stack] = directory_stack
          outputs = Map.get(directory_contents, current_directory)
          outputs = [String.to_integer(file_size) | outputs]

          {Map.put(directory_contents, current_directory, outputs), directory_stack}
      end
    end)
  end

  def calculate_size(contents, full_map) when is_list(contents) do
    Enum.reduce(contents, 0, fn item, acc ->
      acc + calculate_size(item, full_map)
    end)
  end

  def calculate_size(directory_name, full_map) when is_binary(directory_name) do
    full_map
    |> Map.get(directory_name)
    |> calculate_size(full_map)
  end

  def calculate_size(file_size, _full_map) when is_integer(file_size) do
    file_size
  end
end

{contents_map, _} = Day7.Lib.parse_input("input.txt")

Enum.map(contents_map, fn {directory, contents} ->
  {directory, Day7.Lib.calculate_size(contents, contents_map)}
end)
|> Enum.filter(fn {_, value} -> value <= 100_000 end)
|> IO.inspect()
|> Enum.map(fn {_, value} -> value end)
|> Enum.sum()
|> IO.inspect()
