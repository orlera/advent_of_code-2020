defmodule V2020.Day6 do
  @input_file_part1 "lib/day6/input.txt"
  @input_file_part2 "lib/day6/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& single_answers(&1))
    |> Enum.sum()
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
    |> String.split("\n\n")
  end

  defp single_answers(group_answers) do
    group_answers
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.count()
  end
end
