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
    |> Enum.sort()
    |> add_outlet()
    |> to_differential()
    |> consecutive_occurrences()
    |> Enum.filter(fn {differential, _} -> differential == 1 end)
    |> to_combinations()
    |> multiply_values()
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
        nil -> [diff1, diff3 + 1]
        three when adapter + 3 == three -> {diff1, diff3 + 1}
        one when adapter + 1 == one -> {diff1 + 1, diff3}
        _ -> {diff1, diff3}
      end
    end)
  end

  defp to_differential(adapters) do
    adapters
    |> Enum.with_index()
    |> Enum.map(fn {adapter, index} ->
      case Enum.at(adapters, index + 1) do
        nil -> 3
        next_adapter -> next_adapter - adapter
      end
    end)
  end

  defp consecutive_occurrences(differentials) do
    differentials
    |> Enum.reduce([], fn differential, acc ->
      case List.last(acc) do
        {^differential, quantity} -> List.replace_at(acc, -1, {differential, quantity + 1})
        _ -> acc ++ [{differential, 1}]
      end
    end)
  end

  defp to_combinations(occurrences) do
    occurrences
    |> Enum.map(fn {_, quantity} -> fibonacci(quantity + 1) - 1
    end)
  end

  def fibonacci(0), do: 1
  def fibonacci(1), do: 1
  def fibonacci(num), do: fibonacci(num - 1) + fibonacci(num - 2)

  defp multiply_values(factors), do: Enum.reduce(factors, 1, & &1 * &2)
end
