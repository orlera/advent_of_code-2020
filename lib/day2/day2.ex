defmodule V2020.Day2 do
  @input_file_part1 "lib/day2/input.txt"
  @input_file_part2 "lib/day2/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& validate_password(&1))
    |> Enum.count(& &1[:valid?])
    |> IO.puts()
  end

  def solution_part2() do
    @input_file_part2
    |> IO.puts()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(& parse_input_line(&1))
  end

  defp parse_input_line(line) do
    parts = String.split(line)
    min_max =
      parts
      |> Enum.at(0)
      |> String.split("-")
    char =
      parts
      |> Enum.at(1)
      |> String.trim_trailing(":")
    password =
      parts
      |> Enum.at(2)

    %{
      min: min_max |> Enum.at(0) |> String.to_integer(),
      max: min_max |> Enum.at(1) |> String.to_integer(),
      char: char,
      password: password
    }
  end

  defp validate_password(%{min: min, max: max, char: char, password: pass} = input) do
    input
    |> Map.put(
      :valid?,
      pass
      |> String.graphemes
      |> Enum.count(& &1 == char)
      |> number_in_range(min, max)
    )
  end

  defp number_in_range(number, min, max) do
    number <= max && number >= min
  end
end
