defmodule V2020.Day6 do
  @all_questions ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  @input_file_part1 "lib/day6/input.txt"
  @input_file_part2 "lib/day6/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& single_answers_count(&1))
    |> Enum.sum()
    |> IO.puts()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> Enum.map(& everybody_answered_count(&1))
    |> Enum.sum()
    |> IO.puts()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n\n")
  end

  defp single_answers_count(group_answers) do
    group_answers
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.count()
  end

  defp everybody_answered_count(group_answers) do
    group_answers
    |> String.split("\n")
    |> Enum.map(& String.graphemes(&1))
    |> Enum.reduce(@all_questions, fn next_answers, current_answers ->
      current_answers |> Enum.filter(& Enum.member?(next_answers, &1))
    end)
    |> Enum.count()
  end
end
