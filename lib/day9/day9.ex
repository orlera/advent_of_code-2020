defmodule V2020.Day9 do
  @preamble_size 25
  @input_file_part1 "lib/day9/input.txt"
  @input_file_part2 "lib/day9/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> find_corrupt_number(0)
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

  defp find_corrupt_number(number_list, start_position) do
    number_list
    |> Enum.slice(start_position, @preamble_size + 1)
    |> maybe_section_corrupted()
    || find_corrupt_number(number_list, start_position + 1)
  end

  defp maybe_section_corrupted(number_list) do
    {preamble, [number_to_check]} =
      number_list
      |> Enum.split(-1)

    preamble
    |> Enum.sort()
    |> find_numbers_to_sum(number_to_check)
  end

  defp find_numbers_to_sum([candidate1 | rest], sum_number) do
    result =
      rest
      |> Enum.reduce_while(nil, fn candidate2, acc ->
        case candidate1 + candidate2 do
          ^sum_number -> {:halt, {candidate1, candidate2}}
          below_target when below_target < sum_number -> {:cont, acc}
          _ -> {:halt, acc}
        end
      end)

    case result do
      nil -> find_numbers_to_sum(rest, sum_number)
      {_, _} -> nil
    end
  end

  defp find_numbers_to_sum([], sum_number), do: sum_number
end
