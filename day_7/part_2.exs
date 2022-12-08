defmodule Day7.Lib do
  def get_directories_map(input) do
    File.read!(input)
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, fn line, {directory_contents, directory_stack} ->
      case String.split(line, " ") do
        [_, "cd", ".."] ->
          [_current_directory | rest_of_stack] = directory_stack
          {directory_contents, rest_of_stack}

        [_, "cd", directory] ->
          {directory_contents, [directory | directory_stack]}

        [_, "ls"] ->
          {Map.put(directory_contents, Enum.join(directory_stack, "/"), []), directory_stack}

        ["dir", directory_name] ->
          outputs = Map.get(directory_contents, Enum.join(directory_stack, "/"))

          {Map.put(directory_contents, Enum.join(directory_stack, "/"), [directory_name | outputs]),
           directory_stack}

        [file_size, _file_name] ->
          outputs = Map.get(directory_contents, Enum.join(directory_stack, "/"))

          {Map.put(directory_contents, Enum.join(directory_stack, "/"), [
             String.to_integer(file_size) | outputs
           ]), directory_stack}
      end
    end)
  end

  def calculate_size(contents, full_path, full_map) when is_list(contents) do
    Enum.reduce(contents, 0, fn item, acc ->
      acc + calculate_size(item, full_path, full_map)
    end)
  end

  def calculate_size(directory_name, full_path, full_map) when is_binary(directory_name) do
    # Get the contents of the next directory down
    full_map
    |> Map.get(directory_name <> "/" <> full_path)
    # Recursive call to process those contents
    |> calculate_size(directory_name <> "/" <> full_path, full_map)
  end

  def calculate_size(file_size, _full_path, _full_map) when is_integer(file_size) do
    # If the item is an integer, it's a file size so just return it
    file_size
  end

  def get_total_size(full_map) do
    full_map
    |> Enum.map(fn {_, contents} ->
      Enum.map(contents, fn item ->
        if is_integer(item) do
          item
        else
          0
        end
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end

{contents_map, _} = Day7.Lib.get_directories_map("input.txt")
diff = Day7.Lib.get_total_size(contents_map) - 40_000_000

contents_map
|> Enum.map(fn {full_path, contents} ->
  {full_path, Day7.Lib.calculate_size(contents, full_path, contents_map)}
end)
|> Enum.filter(fn {_, value} -> value >= diff end)
|> Enum.min_by(fn {_, value} -> value end)
|> IO.inspect()
