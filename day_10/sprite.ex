defmodule Sprite do
  defstruct x_position: 1

  def get_left_position(%Sprite{x_position: x_position}), do: x_position - 1
  def get_right_position(%Sprite{x_position: x_position}), do: x_position + 1

  def update_position(%Sprite{x_position: x_position}, distance) do
    %Sprite{x_position: x_position + distance}
  end
end
