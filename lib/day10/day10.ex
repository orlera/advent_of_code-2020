defmodule V2020.Day10 do
  @input_file_part1 "lib/day10/input.txt"
  @input_file_part2 "lib/day10/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.sort()
    |> add_outlet()
    |> calculate_differential()
    |> multiply_values()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(& String.to_integer(&1))
  end

  defp add_outlet(adapters), do: [0] ++ adapters

  defp calculate_differential(adapters) do
    adapters
    |> Enum.with_index()
    |> Enum.reduce({0, 0}, fn {adapter, index}, {diff1, diff3} ->
      case Enum.at(adapters, index + 1) do
        nil -> {diff1, diff3 + 1}
        three when adapter + 3 == three -> {diff1, diff3 + 1}
        one when adapter + 1 == one -> {diff1 + 1, diff3}
        _ -> {diff1, diff3}
      end
    end)
  end

  defp multiply_values({factor1, factor2}), do: factor1 * factor2
end
