defmodule CPU do
  alias Sprite

  def get_current_pixel_position(cycles) do
    {rem(cycles, 40), ceil((240 - cycles) / 40) |> trunc() |> Kernel.-(6) |> abs()}
  end

  def draw_pixel?({current_pixel_x, _}, %Sprite{x_position: x_position} = sprite) do
    current_pixel_x >= Sprite.get_left_position(sprite) and
      current_pixel_x <= Sprite.get_right_position(sprite)
  end

  def cycle(current_cycle, %Sprite{} = sprite, screen) do
    {current_pixel_x, current_pixel_y} = CPU.get_current_pixel_position(current_cycle)

    if CPU.draw_pixel?({current_pixel_x, current_pixel_y}, sprite) do
      List.replace_at(screen, current_pixel_y, ["#" | Enum.at(screen, current_pixel_y)])
    else
      List.replace_at(screen, current_pixel_y, ["." | Enum.at(screen, current_pixel_y)])
    end
  end
end

alias Sprite

{_, _, screen} =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.reduce_while({0, %Sprite{}, [[], [], [], [], [], []]}, fn instruction,
                                                                    {cycles, sprite, screen} ->
    %Sprite{x_position: x_position} = sprite

    if instruction =~ "noop" do
      cond do
        cycles + 1 == 240 ->
          updated_screen = CPU.cycle(cycles, sprite, screen)
          {:halt, {cycles + 1, sprite, updated_screen}}

        true ->
          updated_screen = CPU.cycle(cycles, sprite, screen)
          {:cont, {cycles + 1, sprite, updated_screen}}
      end
    else
      diff = String.split(instruction, " ") |> List.last() |> String.to_integer()

      cond do
        cycles + 2 >= 240 ->
          updated_screen = CPU.cycle(cycles, sprite, screen)
          updated_screen = CPU.cycle(cycles + 1, sprite, updated_screen)
          {:halt, {cycles + 2, Sprite.update_position(sprite, diff), updated_screen}}

        true ->
          updated_screen = CPU.cycle(cycles, sprite, screen)
          updated_screen = CPU.cycle(cycles + 1, sprite, updated_screen)
          {:cont, {cycles + 2, Sprite.update_position(sprite, diff), updated_screen}}
      end
    end
  end)

screen |> Enum.map(&Enum.reverse/1) |> Enum.map(&Enum.join/1) |> IO.inspect()
