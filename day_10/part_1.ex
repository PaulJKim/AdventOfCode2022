defmodule CPU do
  def passed_key_cycle?(pre, post) do
    rem(pre + 20, 40) > rem(post + 20, 40)
  end

  def is_key_cycle?(cycle) do
    rem(cycle + 20, 40) == 0
  end

  def round_to_nearest_key_cycle(cycle) do
    round(cycle / 10) * 10
  end
end

{_, _, signal_readings} =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.reduce_while({0, 1, []}, fn instruction, {cycles, sum, signal_strengths} ->
    if instruction =~ "noop" do
      cond do
        cycles + 1 == 220 ->
          {:halt, {cycles + 1, sum, [sum * 220 | signal_strengths]}}

        CPU.is_key_cycle?(cycles + 1) ->
          {:cont, {cycles + 1, sum, [sum * (cycles + 1) | signal_strengths]}}

        true ->
          {:cont, {cycles + 1, sum, signal_strengths}}
      end
    else
      cond do
        cycles + 2 >= 220 ->
          {:halt, {cycles + 2, sum, [sum * 220 | signal_strengths]}}

        CPU.is_key_cycle?(cycles + 2) or CPU.passed_key_cycle?(cycles, cycles + 2) ->
          cycle = CPU.round_to_nearest_key_cycle(cycles)

          {:cont,
           {cycles + 2,
            sum + (String.split(instruction, " ") |> List.last() |> String.to_integer()),
            [sum * cycle | signal_strengths]}}

        true ->
          {:cont,
           {cycles + 2,
            sum + (String.split(instruction, " ") |> List.last() |> String.to_integer()),
            signal_strengths}}
      end
    end
  end)

Enum.sum(signal_readings) |> IO.inspect()
