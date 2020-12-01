defmodule Day1 do
  @input_file_part1 "lib/day1/input.txt"
  @input_file_part2 "lib/day1/input.txt"
  def solution_part1() do
    @input_file_part1
    |> sorted_input()
    |> find_numbers_to_sum(2020)
    |> IO.puts
  end

  def solution_part2() do
    @input_file_part2
    |> sorted_input()
    |> iterative
  end

  defp find_numbers_to_sum([candidate1 | rest], sum_number) do
    result =
      rest
      |> Enum.reduce_while({nil, nil}, fn candidate2, acc ->
        case candidate1 + candidate2 do
          ^sum_number -> {:halt, {candidate1, candidate2}}
          below_target when below_target < sum_number -> {:cont, acc}
          above_target when above_target > sum_number -> {:halt, acc}
        end
      end)

    case result do
      {nil, nil} -> find_numbers_to_sum(rest, sum_number)
      {num1, num2} -> num1 * num2
    end
  end

  # It's past midnight, keeping it simple
  defp iterative(num_list) do
    list_size = Enum.count(num_list) - 1
    Enum.each(0..list_size, fn first_index ->
      Enum.each(1..list_size, fn second_index ->
        Enum.each(2..list_size, fn third_index ->
          first = Enum.at(num_list, first_index)
          second = Enum.at(num_list, second_index)
          third = Enum.at(num_list, third_index)
          if first + second + third == 2020, do: IO.puts(first * second * third)
        end)
      end)
    end)
  end

  defp sorted_input(input_file_path) do
    input_file_path
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(& String.to_integer(&1))
      |> Enum.sort()
  end
end
