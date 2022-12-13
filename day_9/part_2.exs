defmodule RopeNodeHelper do
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

  def is_adjacent?({head_x, head_y}, {cur_x, cur_y}) do
    (head_x == cur_x and (head_y == cur_y + 1 or head_y == cur_y - 1)) or
      (head_y == cur_y and (head_x == cur_x + 1 or head_x == cur_x - 1))
  end

  def is_diagonal?({head_x, head_y}, {cur_x, cur_y}) do
    (head_x == cur_x + 1 and head_y == cur_y + 1) or
      (head_x == cur_x + 1 and head_y == cur_y - 1) or
      (head_x == cur_x - 1 and head_y == cur_y + 1) or
      (head_x == cur_x - 1 and head_y == cur_y - 1)
  end

  defp is_overlapping?({head_x, head_y}, {cur_x, cur_y}) do
    head_x == cur_x and head_y == cur_y
  end

  def is_touching?(head, cur) do
    is_adjacent?(head, cur) or is_diagonal?(head, cur) or is_overlapping?(head, cur)
  end

  def did_diagonal_jump?({old_x, old_y}, {new_x, new_y}) do
    if abs(old_x - new_x) == 1 and abs(old_y - new_y) == 1 do
      true
    else
      false
    end
  end
end

defmodule RopeNode do
  use GenServer

  def start_link(id, name) do
    GenServer.start_link(
      __MODULE__,
      %{my_position: {11, 5}, head_position: {11, 5}, id: id, visited_set: MapSet.new([{11, 5}])},
      name: name
    )
  end

  def give_position(name, position) do
    GenServer.call(name, {:give_position, position})
    position
  end

  def get_position(name) do
    GenServer.call(name, :get_position)
  end

  def send_instruction_to_head({direction, count}) do
    GenServer.call(:node_0, {:send_instruction, {direction, count}})
  end

  def get_visited_set(name) do
    GenServer.call(name, :get_visited_set)
  end

  @impl true
  def init(default) do
    {:ok, default}
  end

  def handle_call(:get_position, _from, state) do
    {:reply, state[:my_position], state}
  end

  def handle_call(:get_visited_set, _from, state) do
    {:reply, state[:visited_set], state}
  end

  def handle_call({:send_instruction, {direction, count}}, _from, state) do
    [_start | new_positions] = RopeNodeHelper.traverse({direction, count}, state[:my_position])

    Enum.each(new_positions, fn new_position ->
      RopeNode.give_position(:"node_#{state[:id] + 1}", new_position)
    end)

    {:reply, :ok, %{state | my_position: List.last(new_positions)}}
  end

  @impl true
  def handle_call({:give_position, {head_new_x, head_new_y}}, _from, state) do
    {head_current_x, head_current_y} = state[:head_position]
    {my_current_x, my_current_y} = state[:my_position]

    {my_new_x, my_new_y} =
      cond do
        # If the head's new position is touching me, I don't need to move
        RopeNodeHelper.is_touching?({head_new_x, head_new_y}, {my_current_x, my_current_y}) ->
          unless is_tail?(state[:id]) do
            RopeNode.give_position(:"node_#{state[:id] + 1}", {my_current_x, my_current_y})
          end

          {my_current_x, my_current_y}

        # If the head and my position started adjacent
        RopeNodeHelper.is_adjacent?(
          {head_current_x, head_current_y},
          {my_current_x, my_current_y}
        ) ->
          # But the head did a diagonal move, I should apply the same move to myself
          {my_new_x, my_new_y} =
            if RopeNodeHelper.did_diagonal_jump?(
                 {head_current_x, head_current_y},
                 {head_new_x, head_new_y}
               ) do
              {my_current_x + (head_new_x - head_current_x),
               my_current_y + (head_new_y - head_current_y)}
            else
              # Otherwise, I should move to the head's old position
              {head_current_x, head_current_y}
            end

          unless is_tail?(state[:id]) do
            RopeNode.give_position(:"node_#{state[:id] + 1}", {my_new_x, my_new_y})
          end

          {my_new_x, my_new_y}

        # If the head and my position started diagonal
        RopeNodeHelper.is_diagonal?(
          {head_current_x, head_current_y},
          {my_current_x, my_current_y}
        ) ->
          # But the head did a diagonal move, I should fill the space between us
          {my_new_x, my_new_y} =
            if RopeNodeHelper.did_diagonal_jump?(
                 {head_current_x, head_current_y},
                 {head_new_x, head_new_y}
               ) do
              case {head_new_x - my_current_x, head_new_y - my_current_y} do
                {0, diff_y} ->
                  {my_current_x, my_current_y + trunc(diff_y / 2)}

                {diff_x, 0} ->
                  {my_current_x + trunc(diff_x / 2), my_current_y}

                {diff_x, diff_y} ->
                  {my_current_x + trunc(diff_x / abs(diff_x)),
                   my_current_y + trunc(diff_y / abs(diff_y))}
              end
            else
              # Otherwise, I should move to the head's old position
              {head_current_x, head_current_y}
            end

          unless is_tail?(state[:id]) do
            RopeNode.give_position(:"node_#{state[:id] + 1}", {my_new_x, my_new_y})
          end

          {my_new_x, my_new_y}
      end

    {:reply, :ok,
     %{
       state
       | head_position: {head_new_x, head_new_y},
         my_position: {my_new_x, my_new_y},
         visited_set: MapSet.put(state[:visited_set], {my_new_x, my_new_y})
     }}
  end

  defp is_tail?(id) do
    if id == 9 do
      true
    else
      false
    end
  end
end

# Start the server
Enum.map(0..9, fn id ->
  RopeNode.start_link(id, :"node_#{id}")
end)

File.read!("input.txt")
|> String.trim()
|> String.split("\n")
|> Enum.each(fn move ->
  [direction, count] = String.split(move, " ")
  RopeNode.send_instruction_to_head({direction, String.to_integer(count)})
end)

RopeNode.get_visited_set(:node_9) |> MapSet.size() |> IO.inspect()
